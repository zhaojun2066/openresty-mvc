--
-- Created by IntelliJ IDEA.
-- User: zhaojun(JUFENG)
-- Date: 2018/11/12
-- Time: 15:52
-- To change this template use File | Settings | File Templates.
--
local json = require("json")
local template = require "resty.template"

local ngx = ngx
local _M = {}
local mt = {
    __index = _M
}
local function set_header(key,value)
    ngx.header[key] = value
end
local function default_header()
    set_header('Content-Type', 'text/html; charset=UTF-8')
end


function _M.new()
    local self = {}
    return setmetatable(self,mt)
end

function _M.render(self,content)
    default_header()
    ngx.print(content)
end

--- 返回html
function _M.html(self,view,data)
    template.render(view,data)
end

-- 返回json
function _M.json(self,content)
    set_header('Content-Type', 'application/json; charset=utf-8')
    ngx.print( json.json_encode(content))
end


return _M

