local luaunit = require("luaunit")
local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")
local ConnectFour = require("lib.connectfour.ConnectFour")

local TestConnectFour = {}

function TestConnectFour:setUp()
	self.connectfour = ConnectFour()
end

function TestConnectFour:test_player()
  luaunit.assertEquals(self.connectfour.player, "X")

end

function TestConnectFour:test_serialize()
  luaunit.assertEquals(self.connectfour:serialize(), ("~~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\nO~~~~~~\nX~~~~~~\n"))
end

return TestConnectFour
