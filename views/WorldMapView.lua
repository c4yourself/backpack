local class = require("lib.classy")
local utils = require("lib.utils")
local subsurface = require("lib.view.SubSurface")
local Rectangle = require("lib.draw.Rectangle")
local WorldMap = class("WorldMapView")
local view = require("lib.view")
local count = 0
--some colors
local path_color = {r = 0, g = 0, b = 0}
local background_color = {r = 119, g = 151, b = 255}
local city_color = {r = 0, g = 0, b = 0}
local cityview

local cities = {
	new_york = {
		name = "New York",
		position = {x = 349/1280, y = 194/720},
		area = {}
	},
	rio = {
		name = "Rio de Janeiro",
		position = {x = 477/1280, y = 403/720},
		area = {}
	},
	london = {
		name = "London",
		position = {x = 620/1280, y = 130/720},
		area = {}
	},
	paris = {
		name ="Paris",
		position = {x = 635/1280, y = 155/720},
		area = {}
	},
	cairo = {
		name = "Cairo",
		position = {x = 730/1280, y = 225/720},
		area = {}
	},
	bombay = {
		name = "Bombay",
		position = {x = 892/1280, y = 257/720},
		area = {}
	},
	sidney = {
		name = "Sidney",
		position = {x = 1177/1280, y = 433/720},
		area = {}
	},
	tokyo = {
		name = "Tokyo",
		position = {x = 1120/1280, y = 195/720},
		area = {}
	}
}

--- Renders a loading screen which shows the traveling path
-- @param surface is the screen with is drawn on
-- @param start is the departure city
-- @param dest is the destination city
-- @param transp is the type of transportion (aeroplane, boat or train)
-- @param this will be the cityview that is render after the trip
function WorldMap:render(surface, start, dest, transp, view)
	count = 0
	self:_paint_world_map(surface)
	transport = transp
	trans_direction = "1"
	cityview = view

	-- 	--set start_node
	start_node = {}
	start_node = cities[start].area

	-- 	--set dest_node
	dest_node = {}
	dest_node = cities[dest].area

	if start_node.x > dest_node.x then
		trans_direction = "2"
	end
	if transport ~= nil then
		callback = utils.partial(self._move_vehicle, self, surface)
		self.stop_timer = sys.new_timer(1, callback)
		self.stop_timer:start()
	end

end

function WorldMap:_move_vehicle(surface)
	local path_width = math.abs(dest_node.x - start_node.x)
	local path_height = dest_node.y - start_node.y
	if trans_direction == "1" then
		self:_paint_world_map(surface)
		surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/" .. transport .. trans_direction .. ".png")),
		nil,
		self:_create_start_rect(start_node.x + count, start_node.y + math.floor((path_height/path_width)*count)) )
		count = count + 13
	elseif trans_direction == "2" then
		self:_paint_world_map(surface)
		surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/" .. transport .. trans_direction .. ".png")),
		nil,
		self:_create_start_rect(start_node.x - count, start_node.y + math.floor(path_height/path_width*count)) )
		count = count + 13
	end
	if count >= path_width - 1 then
		self:_stop_timer(surface)
	end
	gfx.update()
end

function WorldMap:_stop_timer(surface)
	self.stop_timer:stop()
	-- TODO call an event thats render a CityView in a fancier way
	view.view_manager:set_view(cityview)
	gfx.update()
end

function WorldMap:_create_area(x, y)
	return Rectangle(x-5, y-5, 10, 10)
end

function WorldMap:_create_path(x, y)
	return Rectangle(x, y, 1, 3)
end

function WorldMap:_create_start_rect(x, y)
	return Rectangle(x-25, y-15, 50,30)
end

function WorldMap:_create_dest_rect(x, y)
	return Rectangle(x-10, y-10, 30,30)
end

function WorldMap:_paint_world_map(surface)
	local screen_width = surface:get_width()
	local screen_height = surface:get_height()
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/worldmap2.png")))

	for k, v in pairs(cities) do
		v.area = self:_create_area(v.position.x * screen_width, v.position.y * screen_height)
		local city = subsurface(surface, v.area)
		city:clear(city_color)
	end
	gfx.update()
end
return WorldMap
