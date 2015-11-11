local utils = require("lib.utils")
local subsurface = require("lib.view.SubSurface")
local area = require("lib.draw.Rectangle")
local world_map = {}

-- Weights for locating cities
local new_york_pos = {x = 324/1280, y = 194/720}
local rio_pos = {x = 461/1280, y = 388/720}
local london_pos = {x = 615/1280, y = 125/720}
local paris_pos = {x = 630/1280, y = 150/720}
local cairo_pos = {x = 725/1280, y = 220/720}
local bombay_pos = {x = 900/1280, y = 200/720}
local sidney_pos = {x = 1168/1280, y = 428/720}
local tokyo_pos = {x = 1115/1280, y = 190/720}

function world_map.render(surface)
	--some colors
	local background_color = {r = 255, g = 255, b = 255}
	local city_color = {r = 255, g = 0, b = 0}
	local path_color = {r = 0, g = 255, b = 0}



	--Surface size
	local screen_width = surface:get_width()
	local screen_height = surface:get_height()

	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/worldmap.png")))

	new_york_area = _create_area(new_york_pos.x * screen_width, new_york_pos.y * screen_height)
	local new_york = subsurface(surface, new_york_area)
	new_york:clear(city_color)

	rio_area = _create_area(rio_pos.x * screen_width, rio_pos.y * screen_height)
	local rio = subsurface(surface, rio_area)
	rio:clear(city_color)

	london_area = _create_area(london_pos.x * screen_width, london_pos.y * screen_height)
	local london = subsurface(surface, london_area)
	london:clear(city_color)

	paris_area = _create_area(paris_pos.x * screen_width, paris_pos.y * screen_height)
	local paris = subsurface(surface, paris_area)
	paris:clear(city_color)

	cairo_area = _create_area(cairo_pos.x * screen_width, cairo_pos.y * screen_height)
	local cairo = subsurface(surface, cairo_area)
	cairo:clear(city_color)

	bombay_area = _create_area(bombay_pos.x * screen_width, bombay_pos.y * screen_height)
	local bombay = subsurface(surface, bombay_area)
	bombay:clear(city_color)

	local sidney_area = _create_area(sidney_pos.x * screen_width, sidney_pos.y * screen_height)
	local sidney = subsurface(surface, sidney_area)
	sidney:clear(city_color)

	local tokyo_area = _create_area(tokyo_pos.x * screen_width, tokyo_pos.y * screen_height)
	local tokyo = subsurface(surface, tokyo_area)
	tokyo:clear(city_color)

	local path = {}
	for i = 0, sidney_area.x - new_york_area.x - 1 do
		path[i] = {}
		for j = 0, sidney_area.y - new_york_area.y - 1 do
			path[i][j] = subsurface(surface, _create_path(new_york_area.x + i, new_york_area.y + j))
		end
	end

	local path_width = sidney_area.x - new_york_area.x
	local path_length = sidney_area.y - new_york_area.y
	for i = 0, path_width - 1 do
		path[i][math.floor((path_length/path_width)*i)]:clear(path_color)
	end
end

function _create_area(x, y)
	return area(x, y, 10, 10)
end

function _create_path(x, y)
	return area(x, y, 3, 3)
end

return world_map
