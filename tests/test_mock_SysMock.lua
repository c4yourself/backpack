local class = require("lib.classy")
--local PlayerMock = require("lib.mocks.PlayerMock")
local luaunit = require("luaunit")
local SysMock = require("lib.mocks.SysMock")
local PlayerMock = require("lib.mocks.PlayerMock")

local TestSysMock = {}

--Sets up an instans of the object SysMock before each test
function TestSysMock:setUp()
	self.sys = SysMock()
end

--Tests if it returns the fixed time 2355
function TestSysMock:test_time()
	luaunit.assertEquals(self.sys:time(), 2355)
end

--Tests if new_player returns a type player
function TestSysMock:test_new_player()
	local player = PlayerMock()
	luaunit.assertEquals(type(self.sys:new_player()), type(player))
end

return TestSysMock
