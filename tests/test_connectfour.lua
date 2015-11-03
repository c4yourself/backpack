local luaunit = require("luaunit")
local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")
local ConnectFour = require("lib.connectfour.ConnectFour")

local TestConnectFour = {}

function TestConnectFour:setUp()
	self.connectfour = ConnectFour().unserialize("~~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~")

-- fullt bräde
	self.connectfour2 = ConnectFour().unserialize("XOXOXOO\nXOXOXOX\nOXOXOXO\nOXOXOXO\nXOXOXOX\nXOXOXOX") --full table
	self.connectfour3 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\nX~~~~~~\nXO~~~~~\nXO~~~~~\nXO~~~~~") --column X
	self.connectfour4 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~~~~~\n~~~~~~~\n~~~~OOO\n~~~XXXX") -- row X
	self.connectfour5 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~X~~~\n~~XX~~~\n~XOO~~~\nXOOXO~~") -- diagonal 1 X
	self.connectfour6 = ConnectFour().unserialize("~~~~~~~\n~~~~~~~\n~~~O~~~\n~~~XO~~\n~~~OXO~\n~~~XXXO") -- diagonal 2 O
--
	print(self.connectfour:serialize())
	print(self.connectfour2:serialize())
	print(self.connectfour3:serialize())
	print(self.connectfour4:serialize())
	print(self.connectfour5:serialize())
	print(self.connectfour6:serialize())

end

function TestConnectFour:test_player()
  luaunit.assertEquals(self.connectfour2.player, "X")

end

function TestConnectFour:test_serialize()
  luaunit.assertEquals(self.connectfour:serialize(), ("~~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\n"))
end

function TestConnectFour:test_get()
	--luaunit.assertEquals(self.connectfour:get( 6,1), "X")
	--luaunit.assertEquals(self.connectfour:get( 3,1), "O")
	--luaunit.assertEquals(self.connectfour:get( 6,5), nil)
	luaunit.assertEquals(self.connectfour2:get( 6,5), nil)
end

function TestConnectFour:test_get_player()
	luaunit.assertEquals(self.connectfour:get_player(), "O")
end

return TestConnectFour
