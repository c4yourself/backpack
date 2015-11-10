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

function world_map.render(surface, start, dest)
	--some colors
	local background_color = {r = 255, g = 255, b = 255}
	local city_color = {r = 255, g = 0, b = 0}
	local path_color = {r = 0, g = 255, b = 0}

	--This section locates and puts the cities on the map
	local screen_width = surface:get_width()
	local screen_height = surface:get_height()

	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/worldmap.png")))

	local new_york_area = _create_area(new_york_pos.x * screen_width, new_york_pos.y * screen_height)
	local new_york = subsurface(surface, new_york_area)
	new_york:clear(city_color)

	local rio_area = _create_area(rio_pos.x * screen_width, rio_pos.y * screen_height)
	local rio = subsurface(surface, rio_area)
	rio:clear(city_color)

	local london_area = _create_area(london_pos.x * screen_width, london_pos.y * screen_height)
	local london = subsurface(surface, london_area)
	london:clear(city_color)

	local paris_area = _create_area(paris_pos.x * screen_width, paris_pos.y * screen_height)
	local paris = subsurface(surface, paris_area)
	paris:clear(city_color)

	local cairo_area = _create_area(cairo_pos.x * screen_width, cairo_pos.y * screen_height)
	local cairo = subsurface(surface, cairo_area)
	cairo:clear(city_color)

	local bombay_area = _create_area(bombay_pos.x * screen_width, bombay_pos.y * screen_height)
	local bombay = subsurface(surface, bombay_area)
	bombay:clear(city_color)

	local sidney_area = _create_area(sidney_pos.x * screen_width, sidney_pos.y * screen_height)
	local sidney = subsurface(surface, sidney_area)
	sidney:clear(city_color)

	local tokyo_area = _create_area(tokyo_pos.x * screen_width, tokyo_pos.y * screen_height)
	local tokyo = subsurface(surface, tokyo_area)
	tokyo:clear(city_color)

	if start ~= nil and dest ~= nil then
		--set start_node
		local start_node = {}
		if start == "new_york" then
			start_node = new_york_area
		elseif start == "rio" then
			start_node = rio_area
		elseif start == "london" then
			start_node = london_area
		elseif start == "paris" then
			start_node = paris_area
		elseif start == "cairo" then
			start_node = cairo_area
		elseif start == "bombay" then
			start_node = bombay_area
		elseif start == "sidney" then
			start_node = sidney_area
		elseif start == "tokyo" then
			start_node = tokyo_area
		end

		--set dest_node
		local dest_node = {}
		if dest == "new_york" then
			dest_node = new_york_area
		elseif dest == "rio" then
			dest_node = rio_area
		elseif dest == "london" then
			dest_node = london_area
		elseif dest == "paris" then
			dest_node = paris_area
		elseif dest == "cairo" then
			dest_node = cairo_area
		elseif dest == "bombay" then
			dest_node = bombay_area
		elseif dest == "sidney" then
			dest_node = sidney_area
		elseif dest == "tokyo" then
			dest_node = tokyo_area
		end

		--force the trip to be drawn from right
		if start_node.x > dest_node.x then
			local prel = start_node
			start_node = dest_node
			dest_node = prel
		end

		-- This section will show the travel path
		local path_width = dest_node.x - start_node.x
		local path_height = dest_node.y - start_node.y
		local mul = 1
		if path_height < 0 then
			mul = -1
			path_height = math.abs(path_height)
		end

		local path = {}
		for i = 0, path_width - 1 do
			path[i] = {}
			for j = 0, path_height - 1 do
				path[i][j] = subsurface(surface, _create_path(start_node.x + i, start_node.y + mul*j))
			end
		end
		for i = 0, path_width - 1 do
			path[i][math.floor((path_height/path_width)*i)]:clear(path_color)
		end

	end
end

function _create_area(x, y)
	return area(x, y, 10, 10)
end

function _create_path(x, y)
	return area(x, y, 1, 3)
end

return world_map
