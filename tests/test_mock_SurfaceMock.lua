local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local SurfaceMock = require("lib.mocks.SurfaceMock")

local TestMockSurface = {}

function TestMockSurface:test_negative_setUp()
	self.surface_mock = SurfaceMock(-1, -1)
end


--Setup width = 720, height = 1080
function TestMockSurface:setUp()
	self.surface_mock = SurfaceMock(720, 1080)
end

--Tests the default dimension of the surface
function TestMockSurface:test_default_dimensions()
	luaunit.assertEquals(self.surface_mock:get_width(), 720)
	luaunit.assertEquals(self.surface_mock:get_height(), 1080)
end

--Tests that the default color of the surface is black
function TestMockSurface:test_default_color()
	luaunit.assertEquals(self.surface_mock:get_pixel(0, 0).r, 0)
	luaunit.assertEquals(self.surface_mock:get_pixel(self.surface_mock:get_width() - 1
	, self.surface_mock:get_height() - 1).g, 0)
	luaunit.assertEquals(self.surface_mock:get_pixel(self.surface_mock:get_width() - 1, 0).b, 0)
	luaunit.assertEquals(self.surface_mock:get_pixel(0, self.surface_mock:get_height() - 1).a, 0)
end


function TestMockSurface:test_clear()
	rect = {
		x = 0,
		y = 0,
		width = 500,
		height = 500
	}
	c = {
		r = 50,
		g = 50,
		b = 50,
		a = 50
	}
	--self.surface_mock.clear(c, rect)
end




return TestMockSurface
