local class = require("lib.classy")
--local PlayerMock = require("lib.mocks.PlayerMock")
local luaunit = require("luaunit")
local SysMock = require("lib.mocks.SysMock")
local PlayerMock = require("lib.mocks.PlayerMock")
local TimerMock = require("lib.mocks.TimerMock")

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

--Test to create a new Timer
function TestSysMock:test_new_timer()
	local timer = TimerMock()
	luaunit.assertEquals(type(self.sys:new_timer(500, "this doesn't matter")), type(timer))
end

--Test if the root path is correct
-- TODO Is this even right? xD
function TestSysMock:test_new_player()
	luaunit.assertEquals(self.sys:root_path("hejsan"), "")
end


return TestSysMock
