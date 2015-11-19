--A test used to try out the mock classes together
gfx = require("lib.mocks.GfxMock")
local class = require("lib.classy")
local luaunit = require("luaunit")
local SurfaceMock = require("lib.mocks.SurfaceMock")
local SubSurface = require("lib.view.SubSurface")
local Color = require("lib.draw.Color")
local CityView = require("views.CityView")
local view = require("lib.view")
local event = require("lib.event")


local TestMockIntegration = {}

function TestMockIntegration:setUp()
	rect = {
		x = 50,
		y = 50,
		width = 200,
		height = 300
	}
	rect2 = {
		x = 10,
		y = 10,
		width = 50,
		height = 50
	}
	black = Color(255, 255, 255, 255)
	surface = SurfaceMock(1280, 720)
end

function TestMockIntegration:test_subsurface()


	sub = SubSurface(surface, rect)
	sub:clear(black, rect2)
	luaunit.assertEquals(sub:get_width(), 200)
	luaunit.assertEquals(sub:get_height(), 300)
end

function TestMockIntegration:test_something()
	--local city_view = CityView(event.remote_control)
	--view.view_manager:set_view(city_view)
end




return TestMockIntegration
