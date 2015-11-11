local class = require("lib.classy")
local FreetypeMock = require("lib.mocks.FreetypeMock")
local luaunit = require("luaunit")
local SysMock = require("lib.mocks.SysMock")

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
end

return TestSysMock
