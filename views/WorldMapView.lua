local utils = require("lib.utils")
local subsurface = require("lib.view.SubSurface")
local area = require("lib.draw.Rectangle")
local world_map = {}
local cities = {new_york, paris, london, kairo, bombay, sidney, rio, tokyo}

function world_map.render(surface)
	local background_color = {r = 255, g = 255, b = 255}
	local city_color = {r = 255, g = 0, b = 0}
	local path_color = {r = 0, g = 255, b = 0}
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/worldmap.png")))

	new_york_area = _create_area(324, 194)
	local new_york = subsurface(surface, new_york_area)
	new_york:clear(city_color)

	rio_area = _create_area(461, 388)
	local rio = subsurface(surface, rio_area)
	rio:clear(city_color)

	london_area = _create_area(615, 125)
	local london = subsurface(surface, london_area)
	london:clear(city_color)

	paris_area = _create_area(630, 150)
	local paris = subsurface(surface, paris_area)
	paris:clear(city_color)

	cairo_area = _create_area(725, 220)
	local cairo = subsurface(surface, cairo_area)
	cairo:clear(city_color)

	bombay_area = _create_area(900, 200)
	local bombay = subsurface(surface, bombay_area)
	bombay:clear(city_color)

	local sidney_area = _create_area(1168, 428)
	local sidney = subsurface(surface, sidney_area)
	sidney:clear(city_color)

	local tokyo_area = _create_area(1115, 190)
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
