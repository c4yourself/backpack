-- Global font cache to work around a bug on the set-top box
font_cache = {}

local CityView = require("views.CityView")
local event = require("lib.event")
local logger = require("lib.logger")
local SplashView = require("views.SplashView")
local utils = require("lib.utils")
local view = require("lib.view")
local City = require("lib.city")
local Profile = require("lib.profile.Profile")

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

	print(City.cities.cairo.name)
	local profile = Profile("Tstar","Tstar@tstar.com",1975,"M", City.cities.cairo)

	local city_view = CityView(event.remote_control, profile)
	local splash_screen = SplashView(
		"data/images/logo.png", city_view, view.view_manager)

	view.view_manager:set_view(city_view)

--	splash_screen:start(1)

	--gfx.update()

	-- local city_view_2 = CityView2(event.remote_control)
	-- view.view_manager:set_view(city_view_2)
	-- gfx.update()

end
