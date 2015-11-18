local event = require("lib.event")
local logger = require("lib.logger")
local utils = require("lib.utils")
local menu = require("views.menu")
local view = require("lib.view")
local SplashView = require("views.SplashView")
local CityView = require("views.CityView")
local CityView2 = require("views.CityView2")
local ConnectFourComponent = require("components.ConnectFourComponent")

--- This function runs every time a key is pressed
-- The current mapping for the emulator can be found in emulator/zto.lua
-- @param key Key that was pressed
-- @param state Either up or repeat
function onKey(key, state)
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
	--start connectfour
--[[	local cfc = ConnectFourComponent(event.remote_control)
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
--	local city_view_2 = CityView2(event.remote_control)
--	view.view_manager:set_view(city_view_2)

	-- Start with Splash Screen
	-- local splash_view = SplashView(event.remote_control)
	-- view.view_manager:set_view(splash_view)


	local city_view = CityView(event.remote_control)
	view.view_manager:set_view(city_view)
	gfx.update()

	-- local city_view_2 = CityView2(event.remote_control)
	-- view.view_manager:set_view(city_view_2)
	-- gfx.update()

end
