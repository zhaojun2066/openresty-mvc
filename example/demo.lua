--
-- Created by IntelliJ IDEA.
-- User: zhaojun(JUFENG)
-- Date: 2018/11/12
-- Time: 15:55
-- To change this template use File | Settings | File Templates.
--
local logger = ngx.log                                                 --- function ngx log
local ERR = ngx.ERR                                                    --- ngx log  level
local router = require("router")
local app = router.new()

app.post("/",function(req,res)
    local a = req.param.a
    -- local a = req.param["a"]
    res:html("index.html",a)
end)

app.post("/json",function(req,res)
    local a = req.param.a
    -- local a = req.param["a"]
    res:json(a)
end)

app.get("/hello",function(req,res)
    local a = req.param.a
    -- local a = req.param["a"]
    res:html("index.html",a)
end)

app.err(function(req,res)
    res:render("server err..")
end)

--- 过滤器设置，可以重复设置多个，调用顺序和配置前后顺序一样
app.filter("/*",function(req,res)
    -- pre handler
end,
function(req,res)
   -- after hanler
end)

app.go()

