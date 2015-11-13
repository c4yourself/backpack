local luaunit = require("luaunit")
local ConnectFour = require("lib.connectfour.ConnectFour")

local TestConnectFour = {}

function TestConnectFour:setUp()

	self.connectfour1 = ConnectFour().unserialize("XOXOXOO\nXOXOXOX\nOXOXOXO\nOXOXOXO\nXOXOXOX\nXOXOXOX") --full table
	self.connectfour2 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\nX~~~~~~\nXO~~~~~\nXO~~~~~\nXO~~~~~") --column X
	self.connectfour3 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~~~~~\n~~~~~~~\n~~~~OOO\n~~~XXXX") -- row X
	self.connectfour4 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~X~~~\n~~XX~~~\n~XOO~~~\nXOOXO~~") -- diagonal 1 X
	self.connectfour5 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~O~~~\n~~~XO~~\n~~~OXO~\n~~~XXXO") -- diagonal 2 O
	self.connectfour6 = ConnectFour()
	self.connectfour6:move("X", 1)
	self.connectfour6:move("O", 2)
	self.connectfour7 = ConnectFour().unserialize("O~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~") -- full column is_valid_move
	self.connectfour8 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~~~~~\n~X~~~~~\n~OOO~~~\n~XXXOX~") -- row no winner
	self.connectfour9 = ConnectFour().unserialize("~~~~~~~\nX~~~~~~\nOX~~~~~\nXO~~~~~\nXO~~~~~\nXO~~~~~") -- column no winner
	self.connectfour10 = ConnectFour().unserialize("~~~~~~~\n~~~~X~~\n~~~OX~~\n~~XXO~~\n~XOOX~~\nXOOXO~~") -- diagonal 1 no winner
	self.connectfour11 = ConnectFour().unserialize("~~~~~~~\nX~~~~~~\nOX~~~~~\nOOX~~~~\nXOXO~~~\nOXOXX~~") -- diagonal 2 no winner
end

function TestConnectFour:test_player()
  luaunit.assertEquals(self.connectfour1.player, "X")

end

function TestConnectFour:test_serialize()
  luaunit.assertEquals(self.connectfour1:serialize(), ("XOXOXOO\nXOXOXOX\nOXOXOXO\nOXOXOXO\nXOXOXOX\nXOXOXOX\n"))
end

function TestConnectFour:test_unserialize()
	luaunit.assertEquals(ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~~~~~\n~~~~~~~\n~~~~~~~\nXO~~~~~"), self.connectfour6)
end

function TestConnectFour:test_get()
  luaunit.assertEquals(self.connectfour2:get( 5,2), "O")
	luaunit.assertEquals(self.connectfour2:get( 4,1), "X")
	luaunit.assertEquals(self.connectfour2:get( 3,3), nil)
end

function TestConnectFour:test_get_player()
	luaunit.assertEquals(self.connectfour4:get_player(), "O")
	luaunit.assertEquals(self.connectfour5:get_player(), "X")
end

function TestConnectFour:test_get_current_row()
	luaunit.assertEquals(self.connectfour2:get_current_row(1), 2)
	luaunit.assertEquals(self.connectfour2:get_current_row(5), 6)
	luaunit.assertEquals(self.connectfour1:get_current_row(1), 0)
end

function TestConnectFour:test_is_valid_move()
	luaunit.assertEquals(self.connectfour7:is_valid_move("X", 1), false)
	luaunit.assertEquals(self.connectfour7:is_valid_move("X", 0), false)
	luaunit.assertEquals(self.connectfour2:is_valid_move("O", 1), true)
	luaunit.assertEquals(self.connectfour7:is_valid_move("X", 8), false)
	luaunit.assertEquals(self.connectfour7:is_valid_move("X", 7), true)
	luaunit.assertEquals(self.connectfour7:is_valid_move("O", 2), false)
end

function TestConnectFour:test_get_winner()
	luaunit.assertEquals(self.connectfour1:get_winner("O", 1, 7), nil)
	luaunit.assertEquals(self.connectfour2:get_winner("X", 3, 1), "X")
	luaunit.assertEquals(self.connectfour3:get_winner("X", 6, 4), "X")
	luaunit.assertEquals(self.connectfour4:get_winner("X", 3, 4), "X")
	luaunit.assertEquals(self.connectfour5:get_winner("O", 3, 4), "O")
	luaunit.assertEquals(self.connectfour5:get_winner("X", 6, 6), nil)
	luaunit.assertEquals(self.connectfour9:get_winner("X", 2, 2), nil)
	luaunit.assertEquals(self.connectfour10:get_winner("X", 4, 3), nil)
	luaunit.assertEquals(self.connectfour11:get_winner("X", 4, 3), nil)
end

return TestConnectFour
