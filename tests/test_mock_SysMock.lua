local class = require("lib.classy")
local FreetypeMock = require("lib.mocks.FreetypeMock")
local luaunit = require("luaunit")
local SysMock = require("lib.mocks.SysMock")
<<<<<<< HEAD

local TestSysMock = {}
--TODO write tests
-- Tests that the methods works. None of the methods does anything.
function TestSysMock:test_new_freetype()
	--[[
	c = {
    r = 1,
    g = 10,
    b = 32,
    a = 40
  }
	FreetypeMock(c, 5, {x=40, y=50}, "text")
	SysMock.new_freetype(c, 5, {x=40, y=50}, "text")
	local freetype = FreetypeMock(c, 5, {x=40, y=50}, "text")
	luaunit.assertEquals(SysMock.new_freetype(c, 5, {x=40, y=50}, "text"), freetype)
	--luaunit.assertEquals(type(GfxMock.loadpng()), type(surface))
	--local freetype1 = SysMock.new_freetype(c, 5, {x=40, y=50}, "text")
	--luaunit.assertEquals(type(SysMock.new_freetype(c, 5, {x=40, y=50}, "text")), type(freetype))]]

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
