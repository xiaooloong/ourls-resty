local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function (narr, nrec) return {} end
end
local _M = new_tab(0, 8)
_M.db    = new_tab(0, 4)
_M.db_rw = new_tab(0, 8)
_M.db_ro = new_tab(0, 8)
_M.hash  = new_tab(0, 4)

_M.db_rw.host = '127.0.0.1'
_M.db_rw.port = 3306
--_M.db_rw.path = '/var/lib/mysql/mysql.sock'
_M.db_rw.database = 'ourl'
_M.db_rw.user     = 'ourl'
_M.db_rw.password = ''

_M.db_ro.host = '127.0.0.1'
_M.db_ro.port = 3306
--_M.db_ro.path = '/var/lib/mysql/mysql.sock'
_M.db_ro.database = 'ourl'
_M.db_ro.user     = 'ourl'
_M.db_ro.password = ''

_M.hash.salt     = 'ourl'
_M.hash.length   = 5
_M.hash.alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'

_M.proxies = {
    '127.0.0.0/8',
    '10.0.0.0/8',
    '172.16.0.0/12',
    '192.168.0.0/16',
}

_M.db.timeout   = 1000
_M.db.keepalive = 10000
_M.db.poolsize  = 10

_M.log_level = ngx.ALERT
_M.debug = false
return _M