local ffi = require 'ffi'
local ffi_new = ffi.new
local ffi_string = ffi.string
local ffi_typeof = ffi.typeof
local ffi_c = ffi.C
local type = type
local char = string.char
ffi.cdef[[
void free (void *__ptr);
int idna_to_ascii_8z (const char *input, char **output, int flags);
int idna_to_unicode_8z8z (const char *input, char **output, int flags);
]]
local idna = ffi.load('idn')
local buff_ptr_type = ffi_typeof('char *[1]')

local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function (narr, nrec) return {} end
end

local _M = new_tab(0, 4)

_M._VERSION = '0.0.1'

function _M.encode(text)
    if not text or 'string' ~= type(text) or 1 > #text then
        return nil, 'empty string'
    end
    text = text .. char(0)
    local buff_out = ffi_new(buff_ptr_type)
    local ok = idna.idna_to_ascii_8z(text, buff_out, 0)
    if 0 == ok then
        local str = ffi_string(buff_out[0])
        ffi_c.free(buff_out[0])
        return str
    else
        ffi_c.free(buff_out[0])
        return nil, 'failed to encode'
    end
end

function _M.decode(text)
    if not text or 'string' ~= type(text) or 1 > #text then
        return nil, 'empty string'
    end
    text = text .. char(0)
    local buff_out = ffi_new(buff_ptr_type)
    local ok = idna.idna_to_unicode_8z8z(text, buff_out, 0)
    if 0 == ok then
        local str = ffi_string(buff_out[0])
        ffi_c.free(buff_out[0])
        return str
    else
        ffi_c.free(buff_out[0])
        return nil, 'failed to encode'
    end
end

return _M