local city = require("lib.city")
local CityView = require("views.CityView")
local class = require("lib.classy")
local event = require("lib.event")
local Profile = require("lib.profile.Profile")
local utils = require("lib.utils")
local subsurface = require("lib.view.SubSurface")
local Rectangle = require("lib.draw.Rectangle")

local WorldMap = class("WorldMapView")
local view = require("lib.view")

local background_color = {r = 119, g = 151, b = 255}
local city_color = {r = 0, g = 0, b = 0}

local cities = {
	new_york = {
		name = "New York",
		position = {x = 349/1280, y = 194/720}
	},
	rio = {
		name = "Rio de Janeiro",
		position = {x = 477/1280, y = 403/720}
	},
	london = {
		name = "London",
		position = {x = 620/1280, y = 130/720}
	},
	paris = {
		name ="Paris",
		position = {x = 635/1280, y = 155/720}
	},
	cairo = {
		name = "Cairo",
		position = {x = 730/1280, y = 225/720}
	},
	bombay = {
		name = "Bombay",
		position = {x = 892/1280, y = 257/720}
	},
	sidney = {
		name = "Sidney",
		position = {x = 1177/1280, y = 433/720}
	},
	tokyo = {
		name = "Tokyo",
		position = {x = 1120/1280, y = 195/720}
	}
}

function WorldMap:__init(origin, destination, method, view_manager)
	view.View.__init(self)

	self.origin = origin
	self.destination = destination
	self.method = method
	self.view_manager = view_manager or view.view_manager

	self._origin_position = cities[origin.code].position
	self._destination_position = cities[destination.code].position

	local direction = "right"
	if self._origin_position.x > self._destination_position.x then
		direction = "left"
	end


	self.images = {
		map = gfx.loadpng("data/images/worldmap2.png"),
		vehicle = gfx.loadpng(
			"data/images/" .. self.method .. ({left = "1", right = "2"})[direction] .. ".png")
	}
	
	self._step_count = 13
	self._step_index = 0
end

function WorldMap:start()
	self.timer = sys.new_timer(10, function()
		self._step_index = math.min(self._step_index + 1, self._step_count)

		if self._step_index == self._step_count then
			self.timer:stop()

			-- TODO: Fix this to use profile instead
			self.view_manager:set_view(
				CityView(event.remote_control, Profile("Andreas", nil, nil, nil, self.destination.code)))
		end

		self:dirty()
	end)
end

function WorldMap:destroy()
	view.View.destroy(self)

	for _, image in ipairs(self.images) do
		image:destroy()
	end

	self.timer = nil
end
--- Renders a loading screen which shows the traveling path
-- @param surface is the screen with is drawn on
function WorldMap:render(surface)
	-- Calculate step size
	self:_paint_world_map(surface)

	local travel_width = self._destination_position.x - self._origin_position.x
	local travel_height = self._destination_position.y - self._origin_position.y
	local step_x = travel_width / self._step_count
	local step_y = travel_height / self._step_count

	surface:copyfrom(self.images.vehicle, nil, {
		x = surface:get_width() * (self._origin_position.x + step_x * self._step_index) - 15,
		y = surface:get_height() * (self._origin_position.y + step_y * self._step_index) - 15,
		width = 30,
		height = 30
	}, false)

	self:dirty(false)
end

function WorldMap:_paint_world_map(surface)
	surface:clear(background_color)
	surface:copyfrom(self.images.map)

	local city_marker = Rectangle(0, 0, 10, 10)

	for city_code, city_data in pairs(cities) do
		surface:clear(city_color, city_marker:translate(
			city_data.position.x * surface:get_width() - city_marker.width  / 2,
			city_data.position.y * surface:get_height() - city_marker.height  / 2):to_table())
	end
end

return WorldMap
