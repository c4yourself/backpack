local utils = require("lib.utils")
local event = require("lib.event")
local multiple_quiz = require("views.multiple_quiz")
local numerical_quiz = require("views.numerical_quiz")

local menu = {}

function menu.load_view(button)
	if button == "1" then
		numerical_quiz.render(screen)
		gfx.update()
	elseif button == "2" then
		multiple_quiz.render(screen)
	elseif button == "3" then
		print("Shut down program")
		sys.stop()
	end
end

-- This functions renders the menu view
function menu.render(surface)


	-- Resets the surface and draws the background
	local background_color = {r=0, g=0, b=0}
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))

	--creates some colors
	local button_color = {r=0, g=128, b=225}
	local text_color = {r=0, g=0, b=0}
	local score_text_color = {r=255, g=255, b=255}

	-- This makes a freetype to write with
	local text_button1 = sys.new_freetype(text_color, 30, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button2 = sys.new_freetype(text_color, 30, {x=200,y=280}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button3 = sys.new_freetype(text_color, 30, {x=200,y=480}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local score = sys.new_freetype(score_text_color, 40, {x=1010,y=170}, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Shows the score
	score:draw_over_surface(surface, "Score: " .. "125")

	-- Implements Button 1. Numerical
	surface:fill(button_color, {width=500, height=100, x=100, y=50})
	text_button1:draw_over_surface(surface, "1. Numerical quiz")

	-- Implements Button 2. Multiple choice question
	surface:fill(button_color, {width=500, height=100, x=100, y=250})
	text_button2:draw_over_surface(surface, "2. Multiple choice question")

	-- Implements the exit button
	surface:fill(button_color, {width=500, height=100, x=100, y=450})
	text_button3:draw_over_surface(surface, "3. Exit")

	-- Instance remote control and mapps it to the buttons
	event.remote_control:on("button_release", menu.load_view)

end

return menu