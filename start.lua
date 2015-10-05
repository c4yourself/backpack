local Event = require("/lib/event.Event")
local logger = require("lib.logger")

--- This function runs every time a key is pressed
-- The current mapping for the emulator can be found in emulator/zto.lua
-- @param key Key that was pressed
-- @param state Either up or repeat
function onKey(key, state)
	logger.trace("OnKey(" .. key .. ", " .. state .. ")")

	--testing remote control
	if state == "up" then
		remote_control:trigger("button", key)
	end

	-- Terminate program when exit key is pressed
	if key == "exit" and state == "up" then
		sys.stop()
	end
end

-- This function is called at the start of the program
function onStart()
	-- instace of remote control
	remote_control = Event()
	remote_control:on("button", function(button) print() end)

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

	-- Refresh screen to make changes visible
	gfx.update()
end
