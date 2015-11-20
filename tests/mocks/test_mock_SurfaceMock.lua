local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local SurfaceMock = require("lib.mocks.SurfaceMock")
local Color = require("lib.draw.Color")

local TestSurfaceMock = {}




--Setup width = 1080, height = 720
function TestSurfaceMock:setUp()
	self.surface_mock = SurfaceMock(1080, 720)
end

--Test to initiate with negative values
function TestSurfaceMock:test_negative_setUp()
	self.surface_mock = SurfaceMock(-1, -1)
end

--Tests the default dimension of the surface
function TestSurfaceMock:test_default_dimensions()
	luaunit.assertEquals(self.surface_mock:get_width(), 1080)
	luaunit.assertEquals(self.surface_mock:get_height(), 720)
end

--Tests that the default color of the surface is black
function TestSurfaceMock:test_default_color()
	luaunit.assertEquals(self.surface_mock:get_pixel(0, 0), {r = 0, g = 0, b = 0, a = 0})
	luaunit.assertEquals(self.surface_mock:get_pixel(self.surface_mock:get_width() - 1
	, self.surface_mock:get_height() - 1), {r = 0, g = 0, b = 0, a = 0})
	luaunit.assertEquals(self.surface_mock:get_pixel(self.surface_mock:get_width() - 1, 0),
	{r = 0, g = 0, b = 0, a = 0})
	luaunit.assertEquals(self.surface_mock:get_pixel(0, self.surface_mock:get_height() - 1),
	 {r = 0, g = 0, b = 0, a = 0})
end

--Tests that the new colors are correct
function TestSurfaceMock:test_clear()
	rect = {
		x = 0,
		y = 0,
		width = 500,
		height = 500
	}
	local col1 = Color(50, 50, 50, 50)
	local col2 = Color(0, 0, 0, 0)

	self.surface_mock:clear(col1, rect)
	luaunit.assertEquals(self.surface_mock:get_pixel(0, 0), {r = 50, g = 50, b = 50, a = 50})
	luaunit.assertEquals(self.surface_mock:get_pixel(500, 500), {r = 0, g = 0, b = 0, a = 0})
	luaunit.assertEquals(self.surface_mock:get_pixel(0, 499), {r = 50, g = 50, b = 50, a = 50})
	luaunit.assertEquals(self.surface_mock:get_pixel(1079, 719), {r = 0, g = 0, b = 0, a = 0})
end

--inits a too big size and then tries to clear a smaller area within
--Should it return an error?
function TestSurfaceMock:test_init_too_big()
	rect = {
		x = 0,
		y = 0,
		width = 1300,
		height = 1300
	}
	local c = {
		r = 100,
		g = 100,
		b = 100,
		a = 100
	}
	self.surface_mock = SurfaceMock(1500, 1500)
	self.surface_mock:clear(c, rect)
	luaunit.assertEquals(self.surface_mock:get_pixel(1200, 1200), c)
end

--Test get pixel
function TestSurfaceMock:test_get_pixel()
	print (self.surface_mock:get_pixel(500, 500).r)
end






return TestSurfaceMock
