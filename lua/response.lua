--
-- Created by IntelliJ IDEA.
-- User: zhaojun(JUFENG)
-- Date: 2018/11/12
-- Time: 15:52
-- To change this template use File | Settings | File Templates.
--
local json = require("cjson.safe")

local ngx = ngx
local _M = {}
local mt = {
    __index = _M
}

function _M.new()
    local self = {}
    return setmetatable(self,mt)
end

function _M.render(self,content)
    ngx.say(content)
end

--- 返回html
function _M.html(self,data)
    self:set_header('Content-Type', 'text/html; charset=UTF-8')
    self:render(data)
end

-- 返回json
function _M.json(self,content)
    self:set_header('Content-Type', 'application/json; charset=utf-8')
    ngx.render( json.json_encode(content))
end

function _M.set_header(key,value)
    ngx.header[key] = value
end
return _M

