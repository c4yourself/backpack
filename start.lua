local event = require("lib.event")
local logger = require("lib.logger")
local utils = require("lib.utils")

local Color = require("lib.draw.Color")
--local Font = require("lib.font.Font")

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
end

-- This function is called at the start of the program
function onStart()
	screen:clear({255, 255, 255, 255})

	local red = Color(255, 0, 0, 200)
	local green = Color(0, 255, 0, 200)
	local blue = Color(0, 0, 255, 200)

	screen:fill(red:to_table(), {x = 50, y = 50, w = 100, h = 100})
	screen:fill(green:to_table(), {x = 75, y = 75, w = 100, h = 100})
	screen:fill(blue:to_table(), {x = 100, y = 100, w = 100, h = 100})

	screen:clear(red:to_table(), {x = 150, y = 50, w = 100, h = 100})
	screen:clear(green:to_table(), {x = 175, y = 75, w = 100, h = 100})
	screen:clear(blue:to_table(), {x = 200, y = 100, w = 100, h = 100})

	local surf = gfx.new_surface(50, 500)
	surf:clear(Color(0, 0, 0, 127):to_table())

	screen:copyfrom(surf, nil, {x = 100, y = 100})

	for x = 50, 150 do
		for y = 200, 300 do
			screen:set_pixel(x, y, red:to_table())
		end
	end

	--local f = Font("data/fonts/DroidSans.ttf", 32, red)
	--f:draw(screen, {x = 500, y = 100}, "testing")

	gfx.update()
end
