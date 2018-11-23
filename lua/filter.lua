--
-- Created by IntelliJ IDEA.
-- User: zhaojun(JUFENG)
-- Date: 2018/11/23
-- Time: 17:39
-- To change this template use File | Settings | File Templates.
-- uri请求过滤器

local _M={}
local ngx = ngx
local pairs = pairs

local filers = {
}
function _M.filter(path,preHandler,afterHandler)
    if not filers[path] then
        filers[path] = {
            pre = preHandler,
            after = afterHandler
        }
    end
end


function _M.get_fiter_handlers(path)
    local pres = {}
    local afters = {}
    if path == "/" then
        return filers[path]
    end
    for k,v in pairs(filers) do
        local m, err = ngx.re.match(path, k)
        if m and v then
            local pre = v.pre
            local af = v.after
            if pre then
                table.insert(pres,pre)
            end
            if af then
                table.insert(afters,af)
            end
        end
    end
    return pres, afters
end
return _M

