--
-- Created by IntelliJ IDEA.
-- User: zhaojun(JUFENG)
-- Date: 2018/11/12
-- Time: 14:16
-- To change this template use File | Settings | File Templates.
local json = require("json")
local _M={}
local ngx = ngx
local mt ={
    __index = _M
}
local function params()
    local args = {}
    local uri_args = ngx.req.get_uri_args
    if not uri_args then
        for k,v in pairs(uri_args) do
            args[k] = v
        end
    end
    ngx.req.read_body()
    local post_args = ngx.req.get_post_args()
    if not post_args then
        for k,v in pairs(post_args) do
            args[k] =v
        end
    end
end
local function get_post_args()
    local body = {}
    ngx.req.read_body()
    local post_args = ngx.req.get_post_args()
    if not post_args then
        for k,v in pairs(post_args) do
            body[k] =v
        end
    end
    return body
end
local function get_body_data()
    ngx.req.read_body()
    return ngx.req.get_body_data()
end
function _M.new()
    --- 解析客户端发送Content-Type
    local headers,err = ngx.req.headers()
    local body
    if headers then
        local conent_type = headers["Content-Type"]
        if conent_type then
            if conent_type == "application/x-www-form-urlencoded" then
              body = get_post_args()
            elseif conent_type == "application/json" then
                local json_str = get_body_data()
                body = json.json_decode(json_str)
            elseif conent_type == "multipart/form-data " then
                --todo: file upload
            else
                body = get_body_data()
            end
        else
            body = get_post_args()
        end
    end
    local self = {
        query = ngx.req.get_uri_args(),
        body = body,-- post param |bodystr | josndata | file
        uri = ngx.req.uri,
        request_uri = ngx.req.request_uri,
        request_method = ngx.var.request_method,
    }
    return setmetatable(self, mt)
end


-- request 设置request 范围参数，在forward 范围内
function _M.add_param(self,k,v)
    self.body[k] = v
end
--
--_M.param = params()
--_M.uri = ngx.req.uri
--_M.request_uri = ngx.req.request_uri
--_M.request_method = ngx.var.request_method
return _M
