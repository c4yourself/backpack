local event = require("lib.event")
local logger = require("lib.logger")
local utils = require("lib.utils")
local menu = require("views.menu")

--- This function runs every time a key is pressed
-- The current mapping for the emulator can be found in emulator/zto.lua
-- @param key Key that was pressed
-- @param state Either up or repeat
function onKey(key, state)
	logger.trace("OnKey(" .. key .. ", " .. state .. ")")

	--testing remote control
	if state == "up" then
		event.remote_control:trigger("button_release", key)
	end
	-- Terminate program when exit key is pressed
	if key == "exit" and state == "up" then
		sys.stop()
	end
end

-- This function is called at the start of the program
function onStart()

	menu.render(screen)

	--[[
	-- Table with different colors to be drawn as boxes
	local rainbow = {
		{r = 255, g = 0, b = 0},
		{r = 0, g = 255, b = 0},
		{r = 0, g = 0, b = 255},
		{r = 255, g = 255, b = 0},
		{r = 255, g = 0, b = 255},
		{r = 0, g = 255, b = 255},
		{r = 255, g = 255, b = 255},
	}

	-- Create one box per color
	local width = math.floor(screen:get_width() / #rainbow)
	for i, color in ipairs(rainbow) do
		screen:clear(color, {width = width, height = 100, x = width * (i - 1)})
	end

	-- Example of how to print
	font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))
	font:draw_over_surface(screen, "Hello World!")
	]]--

	-- Refresh screen to make changes visible
	gfx.update()
end
