local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local SurfaceMock = require("lib.mocks.SurfaceMock")

local TestMockSurface = {}

function TestMockSurface:test_negative_setUp()
	self.surface_mock = SurfaceMock(-1, -1)
end


--Setup width = 1080, height = 720
function TestMockSurface:setUp()
	self.surface_mock = SurfaceMock(1080, 720)
end

--Tests the default dimension of the surface
function TestMockSurface:test_default_dimensions()
	luaunit.assertEquals(self.surface_mock:get_width(), 1080)
	luaunit.assertEquals(self.surface_mock:get_height(), 720)
end

--Tests that the default color of the surface is black
function TestMockSurface:test_default_color()
	luaunit.assertEquals({self.surface_mock:get_pixel(0, 0)}, {0, 0, 0, 0})
	luaunit.assertEquals({self.surface_mock:get_pixel(self.surface_mock:get_width() - 1
	, self.surface_mock:get_height() - 1)}, {0, 0, 0, 0})
	luaunit.assertEquals({self.surface_mock:get_pixel(self.surface_mock:get_width() - 1, 0)}, {0, 0, 0, 0})
	luaunit.assertEquals({self.surface_mock:get_pixel(0, self.surface_mock:get_height() - 1)}, {0, 0, 0, 0})
end

--Tests that the new colors are correct
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
	self.surface_mock:clear(c, rect)
	luaunit.assertEquals({self.surface_mock:get_pixel(0, 0)}, {50, 50, 50, 50})
	luaunit.assertEquals({self.surface_mock:get_pixel(500, 500)}, {0, 0, 0, 0})
	luaunit.assertEquals({self.surface_mock:get_pixel(0, 499)}, {50, 50, 50, 50})
	luaunit.assertEquals({self.surface_mock:get_pixel(1079, 719)}, {0, 0, 0, 0})
end

--inits a too big size and then tries to clear a smaller area within
--Should it return an error?
function TestMockSurface:test_init_too_big()
	rect = {
		x = 0,
		y = 0,
		width = 1300,
		height = 1300
	}
	c = {
		r = 100,
		g = 100,
		b = 100,
		a = 100
	}
	self.surface_mock = SurfaceMock(1500, 1500)
	self.surface_mock:clear(c, rect)
	luaunit.assertEquals({self.surface_mock:get_pixel(1200, 1200)}, {100, 100, 100, 100})
end





return TestMockSurface
