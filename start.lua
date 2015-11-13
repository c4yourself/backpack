local event = require("lib.event")
local logger = require("lib.logger")
local utils = require("lib.utils")

local Color = require("lib.draw.Color")
local Font = require("lib.font.Font")

local SubSurface = require("lib.view.SubSurface")
local button = require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")

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

	--Subsurface
	--sub = SubSurface(screen, {x = 300, y = 300, width = 400, height = 400})
	--sub:clear()

	--local f = Font("data/fonts/DroidSans.ttf", 32, red)
	--f:draw(screen, {x = 500, y = 100}, "testing")
	--Draw kallar på get_text_surface som bara är lokal

	--Buttons
	local button_color = color(0, 128, 225, 255)
	local text_color = color(55, 55, 55, 255)
	local score_text_color = color(255, 255, 255, 255)
	local color_selected = color(33, 99, 111, 255)
	local color_disabled = color(111, 222, 111, 255) --have not been used yet

	-- Instance of	all Buttons
	local button_1 = button(button_color, color_selected, color_disabled,true,true)
	button_1:set_textdata("Numerical quiz",text_color,{x=100,y=50},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	--local button_2 = button(button_color, color_selected, color_disabled,true,false)
	--local button_3 = button(button_color, color_selected, color_disabled,true,false)

 -- Define each button's posotion and size
	local position_1={x=100,y=50}
	local button_size_1 = {width=500,height=100}
	--button_1:render(screen)
	local score = sys.new_freetype(score_text_color:to_table(), 40, {x=1010,y=170}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	score:draw_over_surface(screen, "Score: " .. "125")

	-- create a button grid for the current view,
	-- for managing all buttons' layout and states
	--self.buttonGrid = button_grid()

	-- Using the button grid to create buttons
	--self.buttonGrid:add_button(position_1,button_size_1,button_1)
	--self.buttonGrid:add_button(position_2,button_size_2,button_2)
	--self.buttonGrid:add_button(position_3,button_size_3,button_3)


	gfx.update()
end
