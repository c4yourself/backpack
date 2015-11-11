local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local SurfaceMock = require("lib.mocks.SurfaceMock")
local GfxMock = require("lib.mocks.GfxMock")

local TestGfxMock = {}

--Tests that the methods memory returns the correct values
function TestGfxMock:test_memory()
   luaunit.assertEquals(GfxMock.get_memory_use(), 0)
   luaunit.assertEquals(GfxMock.get_memory_limit(), 1)
end

--Tests that a surface is created correctly
function TestGfxMock:test_surface()
  local surface = GfxMock.new_surface(12, 7)
  luaunit.assertEquals(surface:get_width(), 12)
  luaunit.assertEquals(surface:get_height(), 7)
end

--Tests that the update does not do anything
function TestGfxMock:test_update()
  GfxMock.update()
  GfxMock.set_auto_update()
end

--Tests that the loadjpeg/png returns a surface (output dimensions
--not necessary)
function TestGfxMock:test_load()
  local surface = GfxMock.new_surface(12, 7)
  luaunit.assertEquals(type(GfxMock.loadjpeg()), type(surface))
  luaunit.assertEquals(type(GfxMock.loadpng()), type(surface))
end

return TestGfxMock
