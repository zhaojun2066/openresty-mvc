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
local function runHandler(uri,req,res)
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
         --- 应该用pcall 来实现 捕获error 或者assert 抛出的异常信息，跳转到错误页面
        err_handler(req,res)
    end
end

function _M.go()
    local req = request.new()
    local res = response.new()
    local uri = req.uri
    runHandler(uri,req,res)
end

---todo: ngx.reg.gsub
local function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end
local function set_params_from_path(path,req)
    local i,j=  ngx.re.find(path,"?")
    if i then
        local ps =  string.sub(path,j+1)
        if ps then
            local params = split(ps,"&")
            if params then
                local kv = split(params,"=")
                if kv then
                    req:add_param(kv[0],kv[1])
                end
            end
        end
    end
end
--- forward 内部handler 跳转
function _M.forward(path,req,res)
    if path then
        set_params_from_path(path,req)
        runHandler(path,req,res)
    else
        err_handler(req,res)
    end


end

--- 重定向 redirect
function _M.redirect(path)
   return ngx.redirect(path, 302)
end
return _M