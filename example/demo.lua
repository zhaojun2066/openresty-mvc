--
-- Created by IntelliJ IDEA.
-- User: zhaojun(JUFENG)
-- Date: 2018/11/12
-- Time: 15:55
-- To change this template use File | Settings | File Templates.
--

local router = require("router")
local app = router.new()

app.post("/",function(req,res)
    local a = req.param.a
    -- local a = req.param["a"]
    res:render(a)
end)

app.err(function(req,res)
    res:render("page err..")
end)

app.go()

