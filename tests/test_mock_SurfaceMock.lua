local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local SurfaceMock = require("lib.mocks.SurfaceMock")

local TestMockSurface = {}

--Setup width = 720, height = 1080
function TestMockSurface:setUp()
    self.SurfaceMock = SurfaceMock(720, 1080)
end

--Tests the default dimension of the surface
function TestMockSurface:test_default_dimensions()
    --luaunit.assertEquals(self.SurfaceMock.get_width, 720)
    --luaunit.assertEquals(self.SurfaceMock.get_height, 1080)
end

--Tests that the default color of the surface is black
function TestMockSurface:test_default_color()

end



return TestMockSurface
