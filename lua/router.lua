--
-- Created by IntelliJ IDEA.
-- User: zhaojun(JUFENG)
-- Date: 2018/11/12
-- Time: 14:16
-- To change this template use File | Settings | File Templates.
-- 存储所有路由规则 ，现在是简单的url 匹配

local request = require("request")
local response = require("response")
local filters = require("filters")

local ngx = ngx
local pairs= pairs
local _M={}
local mt = {
    __index = _M
}
--- 所有路由规则
local routes = {
    post = {},
    get = {}
}

--- 错误处理器
local err_handler

function _M.new()
    local self = {
    }
    return setmetatable(self, mt)
end

function _M.err(handler)
    if not err_handler then
        err_handler = handler
    end
end

function _M.post(uri,handler)
    --- 查找routes中post 中匹配uri的对应handler
    if not routes.post[uri] then
        routes.post[uri] = handler
    end
end

function _M.get(uri,handler)
    if not routes.get[uri] then
        routes.get[uri] = handler
    end
end

function _M.go()
    local req = request.new()
    local res = response.new()
    local uri = req.uri
    local request_method = req.request_method
    local handler
    if "GET" == request_method then
         handler = routes.get[uri]
    elseif "POST" == request_method then
         handler = routes.post[uri]
    end
    if  handler then
        local pre_handlers, after_handlers= filters.get_fiter_handlers(uri)
        if pre_handlers then
            for _,pre_handler in pairs(pre_handlers) do
                pre_handler(req,res)
            end
        end

        handler(req,res)

        if after_handlers then
            for _,after_handler in pairs(after_handlers) do
                after_handler(req,res)
            end
        end
    else
        err_handler(req,res)
    end
end

return _M