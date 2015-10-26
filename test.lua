local connectfour = require("lib.connectfour")
local a = connectfour.ConnectFour()

print(a:serialize())

--[[print(a:get(6,4))
print(a:get(2,3))
print(a:get(6,1))--]]

--print(a:get_player())
--print(a:is_valid_move("O",2))
--a:move("O",2)

print(a:serialize())
--print(a:get_winner(X, 1, 1))
