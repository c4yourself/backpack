local utils = require("lib.utils")
local event = require("lib.event")
local menu = {}


-- This functions renders the menu view
function menu.render(surface)


	-- Resets the surface and draws the background
	local backgroundColor = {r=0, g=0, b=0}
	surface:clear(backgroundColor)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))

	--creates some colors
	local buttonColor = {r=0, g=128, b=225}
	local exit_buttonColor = {r=255, g=102, b=0}
	local textColor = {r=0, g=0, b=0}
	local score_textColor = {r=255, g=255, b=255}

	-- This makes a freetype to write with
	local textButton1 = sys.new_freetype(textColor, 30, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local textButton2 = sys.new_freetype(textColor, 30, {x=200,y=280}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local textButton3 = sys.new_freetype(textColor, 30, {x=200,y=480}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local score = sys.new_freetype(score_textColor, 40, {x=1010,y=170}, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Shows the score
	score:draw_over_surface(surface, "Score: " .. "125")

	-- Implements Button 1. Numerical
	surface:fill(buttonColor, {width=500, height=100, x=100, y=50})
	textButton1:draw_over_surface(surface, "1. Numerical quiz")

	-- Implements Button 2. Multiple choice question
	surface:fill(buttonColor, {width=500, height=100, x=100, y=250})
	textButton2:draw_over_surface(surface, "2. Multiple choice question")

	-- Implements the exit button
	surface:fill(exit_buttonColor, {width=500, height=100, x=100, y=450})
	textButton3:draw_over_surface(surface, "3. Exit")

	-- Instance remote control and mapps it to the buttons
	event.remote_control:on("button_release", function(button)
		if button == "1" then
			print("Numerical")
		elseif button == "2" then
			print("Multiple")
		elseif button == "3" then
			print("Shut down program")
			sys.stop()
		end
	end)

end

return menu
