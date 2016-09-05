local config = require 'ourl.config'
local router = require 'lib.router'
local hashid = require 'lib.hashids.init'
local json   = require 'cjson'
local mysql  = require 'resty.mysql'
local r_sha1 = require 'resty.sha1'
local r_str  = require 'resty.string'

local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function (narr, nrec) return {} end
end

local STATUS_ERR = 0
local STATUS_OK  = 1
local r, h, db_rw, db_ro

local function log(...)
    ngx.log(config.log_level, ...)
end

local function finish()
    for _, db in ipairs({db_rw, db_ro}) do
        db:set_keepalive(config.db.keepalive, config.db.poolsize)
    end
end

local function json_api(t)
    finish()
    if 'table' ~= type(t) then
        t = {t}
    end
    ngx.status = ngx.HTTP_OK
    ngx.header['Content-Type'] = 'application/json'
    ngx.print(json.encode(t))
    return ngx.exit(ngx.status)
end

local function die(msg, code)
    code = code or STATUS_ERR
    msg = msg or ''
    json_api({
        status = code,
        msg = msg
    })
end

local function db_query(db, query)
    local ok, err = db:send_query(query)
    if not ok then
        log('failed to send query: ', query, ' : ', err)
        die('数据库错误')
    end
    
    local res, err, errcode, sqlstate = db:read_result()
    if not res then
        log('failed to read result of query: ', query, errcode, ': ', err, sqlstate)
        die('数据库错误')
    elseif config.debug then
        log('[DEBUG]: ' .. json.encode({query, res, errcode, err, sqlstate}))
    end
    
    return res, err, errcode, sqlstate
end

local function ip2long(ip)
    local l = 0
    for v in ip:gmatch([=[[^\.]+]=]) do
        l = l * 256 + v
    end
    return l
end

local function real_remote_addr()
    --Todo: 判断代理
    return ip2long(ngx.var.remote_addr)
end

local function test(params)
    for k, v in pairs(params) do
        if '' == type(v) then
            ngx.say(k, ': ', table.concat(v, ', '))
        else
            ngx.say(k, ': ', v)
        end
    end
end

local function shorten(params)
    local url = params.url
    if not url then
        die('请传入正确的 url')
    end
    if 'table' ==  type(url) then
        url = url[1]
    end
    local sha1 = r_sha1:new()
    sha1:update(url)
    local digest = r_str.to_hex(sha1:final())
    local query = "SELECT `id` FROM `urls` WHERE `sha1`=" .. ngx.quote_sql_str(digest)
    local res = db_query(db_ro, query)
    local id = 0
    if #res > 0 then
        id = res[1]['id']
    else
        local ip = real_remote_addr()
        local query = ("INSERT INTO `urls` (`sha1`, `url`, `create_at`, `creator`) VALUES (%s, %s, %s, %s)"):format(
            ngx.quote_sql_str(digest),
            ngx.quote_sql_str(url),
            ngx.quote_sql_str(ngx.time()),
            ngx.quote_sql_str(ip)
        )
        local res = db_query(db_rw, query)
        id = res['insert_id']
    end
    id = tonumber(id)
    if not id then
        die('服务器错误')
    end
    local s = h:encode(id)
    json_api({
        status = STATUS_OK,
        s_url  = ngx.var.scheme .. [[://]] .. ngx.var.host .. [[/]] .. s
    })
end

local function expand(params)
    local s = params.s_url
    if not s then
        die('请传入短链接')
    end
    if 'table' == type(s) then
        s = s[1]
    end
    local m = ngx.re.match(s, [[^https?://]] .. ngx.var.host .. [=[/([]=] .. config.hash.alphabet .. [=[]{]=] .. config.hash.length .. [=[})]=])
    if m then
        s = m[1]
        local id = h:decode(s)
        if not id or not id[1] then
            die('短地址无法解析')
        end
        local query = "SELECT `url` FROM `urls` WHERE `id`=" .. ngx.quote_sql_str(id[1])
        local res = db_query(db_ro, query)
        if #res > 0 then
            json_api({
                status = STATUS_OK,
                url = res[1]['url']
            })
        else
            die('地址不存在')
        end
    else
        die('请传入正确的短链接')
    end
end

local function redirect(params)
    local hash = params.hash
    if not hash then
        die('请传入短地址')
    end
    if 'table' == type(hash) then
        hash = hash[1]
    end
    local id = h:decode(hash)
    if not id or not id[1] then
        die('请传入正确的短地址')
    end
    local query = "SELECT `url` FROM `urls` WHERE `id`=" .. ngx.quote_sql_str(id[1])
    local res = db_query(db_ro, query)
    if #res > 0 then
        local query = "UPDATE `urls` SET `count`=`count`+1 WHERE `id`=" .. ngx.quote_sql_str(id[1])
        db_query(db_rw, query)
        finish()
        ngx.redirect(res[1]['url'], ngx.HTTP_MOVED_TEMPORARILY)
    else
        die('地址不存在')
    end
end
local _M = new_tab(0, 8)

_M._VERSION = '0.1'

local function prepare()
    local err
    db_rw, err = mysql:new()
    if not db_rw then
        log('failed to init mysql master: ', err)
        die('数据库错误')
    end
    db_ro, err = mysql:new()
    if not db_ro then
        log('failed to init mysql slave: ', err)
        die('数据库错误')
    end
    for name, db in pairs({db_rw = db_rw, db_ro = db_ro}) do
        db:set_timeout(config.db.timeout)
        local ok, err, errcode, sqlstate = db:connect(config[name])
        if not ok then
            log('failed to connect to mysql: ', name, err, errcode, sqlstate)
            die('数据库错误')
        end
        local count
        count, err = db:get_reused_times()
        if 0 == count then
            db_query(db, [[SET NAMES 'utf8';]])
        elseif err then
            log('failed to get reused times: ', name, err)
            die('数据库错误')
        end
    end

    if not r then
        r = router.new()
        r:get('/test', test)
        r:get('/shorten', shorten)
        r:get('/expand', expand)
        r:get('/:hash', redirect)
    end
    if not h then
        h = hashid.new(config.hash.salt, config.hash.length, config.hash.alphabet)
    end
    ngx.req.read_body()
end

function _M.run()
    prepare()
    local ok, err = r:execute(
        ngx.var.request_method,
        ngx.var.uri,
        ngx.req.get_uri_args(),
        ngx.req.get_post_args()
    )
    if not ok then
        if config.debug then
            die('服务器错误' .. err)
        else
            finish()
            ngx.status = ngx.HTTP_NOT_FOUND
            return ngx.exit(ngx.status)
        end
    end
end

return _M