local class = require("lib.classy")
local utils = require("lib.utils")
local subsurface = require("lib.view.SubSurface")
local Rectangle = require("lib.draw.Rectangle")
local WorldMap = class("WorldMapView")

-- Weights for locating cities
local new_york_pos = {x = 324/1280, y = 194/720}
local rio_pos = {x = 461/1280, y = 388/720}
local london_pos = {x = 615/1280, y = 125/720}
local paris_pos = {x = 630/1280, y = 150/720}
local cairo_pos = {x = 725/1280, y = 220/720}
local bombay_pos = {x = 900/1280, y = 200/720}
local sidney_pos = {x = 1168/1280, y = 428/720}
local tokyo_pos = {x = 1115/1280, y = 190/720}
local count = 0
--some colors
local path_color = {r = 0, g = 0, b = 0}
local background_color = {r = 119, g = 151, b = 255}
local city_color = {r = 0, g = 0, b = 0}
local cityview

-- cities.london eller cities["london"]

local cities = {
	new_york = {
		name = "New York",
		position = {x = 324/1280, y = 194/720},
		area = {}
	},
	rio = {
		name = "Rio de Janeiro",
		position = {x = 461/1280, y = 388/720},
		area = {}
	},
	london = {
		name = "London",
		position = {x = 615/1280, y = 125/720},
		area = {}
	},
	paris = {
		name ="Paris",
		position = {x = 630/1280, y = 150/720},
		area = {}
	},
	cairo = {
		name = "Cairo",
		position = {x = 725/1280, y = 220/720},
		area = {}
	},
	bombay = {
		name = "Bombay",
		position = {x = 900/1280, y = 200/720},
		area = {}
	},
	sidney = {
		name = "Sidney",
		position = {x = 1168/1280, y = 428/720},
		area = {}
	},
	tokyo = {
		name = "Tokyo",
		position = {x = 1115/1280, y = 190/720},
		area = {}
	}
}

function WorldMap:render(surface, start, dest, transp, view)
	transport = transp
	trans_direction = "1"
	cityview = view
	-- self:_paint_world_map(surface)
	--
	-- if start ~= nil and dest ~= nil then
	-- 	--set start_node
	-- 	start_node = {}
	-- 	if start == "new_york" then
	-- 		start_node = new_york_area
	-- 	elseif start == "rio" then
	-- 		start_node = rio_area
	-- 	elseif start == "london" then
	-- 		start_node = london_area
	-- 	elseif start == "paris" then
	-- 		start_node = paris_area
	-- 	elseif start == "cairo" then
	-- 		start_node = cairo_area
	-- 	elseif start == "bombay" then
	-- 		start_node = bombay_area
	-- 	elseif start == "sidney" then
	-- 		start_node = sidney_area
	-- 	elseif start == "tokyo" then
	-- 		start_node = tokyo_area
	-- 	end
	--
	-- 	--set dest_node
	-- 	dest_node = {}
	-- 	if dest == "new_york" then
	-- 		dest_node = new_york_area
	-- 	elseif dest == "rio" then
	-- 		dest_node = rio_area
	-- 	elseif dest == "london" then
	-- 		dest_node = london_area
	-- 	elseif dest == "paris" then
	-- 		dest_node = paris_area
	-- 	elseif dest == "cairo" then
	-- 		dest_node = cairo_area
	-- 	elseif dest == "bombay" then
	-- 		dest_node = bombay_area
	-- 	elseif dest == "sidney" then
	-- 		dest_node = sidney_area
	-- 	elseif dest == "tokyo" then
	-- 		dest_node = tokyo_area
	-- 	end
	--
	-- 	path_width = dest_node.x - start_node.x
	-- 	path_height = dest_node.y - start_node.y
	-- 	if start_node.x > dest_node.x then
	-- 		trans_direction = "2"
	-- 	end
		self:_paint_world_map_test_edition_function_awesome(surface)
	-- 	 if transport ~= nil then
	-- 		 callback = utils.partial(self._move_vehicle, self, surface)
	-- 		 self.stop_timer = sys.new_timer(1, callback)
	-- 		 self.stop_timer:start()
	--
	-- 	end
	-- end
end

function WorldMap:_move_vehicle(surface)
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
		self:_create_start_rect(start_node.x - count, start_node.y + math.floor(path_height/math.abs(path_width)*count)) )
		count = count + 13
	end
	if count >= math.abs(path_width - 1) then
		self:_stop_timer(surface)
	end
	gfx.update()
end

function WorldMap:_stop_timer(surface)
	self.stop_timer:stop()
	cityview:render(surface)
	-- TODO call an event thats render a CityView
end

function WorldMap:_create_area(x, y)
	return Rectangle(x, y, 10, 10)
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
	--This section locates and puts the cities on the map
	local screen_width = surface:get_width()
	local screen_height = surface:get_height()
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/worldmap2.png")))

	new_york_area = self:_create_area(new_york_pos.x * screen_width, new_york_pos.y * screen_height)
	local new_york = subsurface(surface, new_york_area)
	new_york:clear(city_color)

	rio_area = self:_create_area(rio_pos.x * screen_width, rio_pos.y * screen_height)
	local rio = subsurface(surface, rio_area)
	rio:clear(city_color)

	london_area = self:_create_area(london_pos.x * screen_width, london_pos.y * screen_height)
	local london = subsurface(surface, london_area)
	london:clear(city_color)

	paris_area = self:_create_area(paris_pos.x * screen_width, paris_pos.y * screen_height)
	local paris = subsurface(surface, paris_area)
	paris:clear(city_color)

	cairo_area = self:_create_area(cairo_pos.x * screen_width, cairo_pos.y * screen_height)
	local cairo = subsurface(surface, cairo_area)
	cairo:clear(city_color)

	bombay_area = self:_create_area(bombay_pos.x * screen_width, bombay_pos.y * screen_height)
	local bombay = subsurface(surface, bombay_area)
	bombay:clear(city_color)

	sidney_area = self:_create_area(sidney_pos.x * screen_width, sidney_pos.y * screen_height)
	local sidney = subsurface(surface, sidney_area)
	sidney:clear(city_color)

	tokyo_area = self:_create_area(tokyo_pos.x * screen_width, tokyo_pos.y * screen_height)
	local tokyo = subsurface(surface, tokyo_area)
	tokyo:clear(city_color)
	gfx.update()
end

function WorldMap:_paint_world_map_test_edition_function_awesome(surface)
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
