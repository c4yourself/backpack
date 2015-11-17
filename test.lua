local connectfour = require("lib.connectfour")
local a = connectfour.ConnectFour()

--print(a:serialize())

local b = connectfour.ConnectFour().unserialize("~~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\n")
print("~~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\n")
print(b:serialize())

a:move("X", 5)
print(a:serialize())

--[[] a:move("X", 4)
print(a:serialize())
a:move("O", 5)
print(a:serialize())
a:move("X", 5)
print(a:serialize())
a:move("O", 6)
print(a:serialize())
a:move("X", 6)
print(a:serialize())
a:move("X",6)
print(a:serialize())
a:move("O", 7)
print(a:serialize())
a:move("X", 6)
print(a:serialize())
a:move("O", 7)
print(a:serialize())
a:move("O", 7)
print(a:serialize())
a:move("X", 7)
print(a:serialize())
a:move("O", 1)
print(a:serialize())
a:move("X", 7)
print(a:serialize()) --]]


--a:move("X", 7)
--print(a:serialize())


--[[a:move("O", 7)
print(a:serialize())
a:move("X", 6)
print(a:serialize())
a:move("O", 6)
print(a:serialize())
a:move("X", 5)
print(a:serialize())
a:move("O", 5)
print(a:serialize())
a:move("X", 4)
print(a:serialize())
a:move("O", 4)
print(a:serialize())--]]

--[[print(a:get(6,4))
print(a:get(2,3))
print(a:get(6,1))--]]

--print(a:get_player())
--print(a:is_valid_move("O",2))
--a:move("O",2)

--print(a:serialize())
--print(a:get_winner("X", 2, 4))
