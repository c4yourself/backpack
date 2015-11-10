local event = require("lib.event")
local logger = require("lib.logger")
local utils = require("lib.utils")


--local menu = require("views.menu")
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
	--menu.render(screen)
	local cfc = ConnectFourComponent()
	cfc:render(screen)
	gfx.update()
end
