-- Global font cache to work around a bug on the set-top box
font_cache = {}

local CityView = require("views.CityView")
local event = require("lib.event")
local logger = require("lib.logger")
local SplashView = require("views.SplashView")
local utils = require("lib.utils")
local view = require("lib.view")
local City = require("lib.city.City")
local Country = require("lib.country.Country")

--- This function runs every time a key is pressed
-- The current mapping for the emulator can be found in emulator/zto.lua
-- @param key Key that was pressed
-- @param state Either up or repeat
function onKey(key, state)
	font_cache = font_cache

	logger.trace("Remote control input (" .. key .. ", " .. state .. ")")

	--testing remote control
	if state == "down" then
		event.remote_control:trigger("button_press", key)
	elseif state == "up" then
		event.remote_control:trigger("button_release", key)
	else
		event.remote_control:trigger("button_repeat", key)
	end

	-- Terminate program when exit key is pressed
	if key == "exit" and state == "up" then
		sys.stop()
	end
end

-- This function is called at the start of the program
function onStart()

	logger.trace("Started")
	-- Init each country.
	local france = Country(France, FRA, "%.2f €", {Paris = City("paris", "Paris", france, nil)}, 1)
	local egypt = Country(Egypt, EGY, "%.2f ج.م", {Cairo = City("cairo", "Cairo", egypt, nil)}, 1)
	local city_view = CityView(event.remote_control, egypt.cities.Cairo)
	local splash_screen = SplashView(
		"data/images/logo.png", city_view, view.view_manager)

	view.view_manager:set_view(splash_screen)

	--start connectfour
--[[local cfc = ConnectFourComponent(event.remote_control)
	view.view_manager:set_view(cfc)
	gfx.update()

	local callback_dirty =function()
		cfc:render(screen)
		gfx.update()
	end
	cfc:on("dirty",callback_dirty) ]]--

	--menu.render(screen)
  --local city_view = CityView(event.remote_control)
	--view.view_manager:set_view(city_view)

	-- the "up" and "down" buttons are enabled for
	-- choosing alternatives in city_view_2

	splash_screen:start(50)

	gfx.update()

	--local city_view = CityView(event.remote_control)
	--view.view_manager:set_view(city_view)
	--gfx.update()

	--local city_view_2 = CityView2(event.remote_control)
	--view.view_manager:set_view(city_view_2)
	--gfx.update()
end
