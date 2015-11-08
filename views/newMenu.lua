local utils = require("lib.utils")
local event = require("lib.event")
local numerical_quiz_view = require("views.NumericalQuizView")
local multiplechoice_quiz = require("views.multiplechoice_quiz")
local subsurface = require("lib.view.Subsurface")
local button= require("lib.components.Button")
local button_grid=require("lib.components.ButtonGrid")
local color = require("lib.color.Color")

local newMenu = {}

function newMenu.load_view(button)
	if button == "1" then
		numerical_quiz_view.render(screen)
		gfx.update()
	elseif button == "2" then
		multiplechoice_quiz.render(screen)
		gfx.update()
	elseif button == "3" then
		print("Shut down program")
		sys.stop()
	elseif button == "down" then

	end
end

-- This functions renders the menu view
function newMenu.render(surface)

local background_color = {r=100, g=0, b=0}
--surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))
surface:clear(background_color)

local normal_color= color(88, 233, 77, 200)
local color_selected = color(254, 254, 254, 210)
local color_disabled = color(0, 0, 0, 255)
button_1 = button(normal_color, color_selected, color_disabled,true,false)
button_2 = button(normal_color, color_selected, color_disabled,true,false)
local position_1={x=100,y=100}
local position_2={x=560,y=380}
local button_size_1 = {width=100,height=500}
local button_size_2 = {width=300,height=200}

buttonGrid = button_grid()
buttonGrid:add_button(position_1,button_size_1,button_1)
buttonGrid:add_button(position_2,button_size_2,button_2)


local text_color = {r=222, g=111, b=99,a=244}
local sub_surface= {100,500}
local the_smaller_one =100
--local fontSize = 0.9 * the_smaller_one
--local font_position
local text="i"
local text_length=text:len();

local test_font_color= color(0, 0, 0, 200)

button_3 = button(test_font_color, color_selected, color_disabled,true,false)
button_4 = button(test_font_color, color_selected, color_disabled,true,false)
local position_3={x=100,y=100}
local button_size_3 = {width=1,height=400}
local position_4={x=124,y=100}
local button_size_4 = {width=1,height=400}
buttonGrid:add_button(position_3,button_size_3,button_3)
buttonGrid:add_button(position_4,button_size_4,button_4)

buttonGrid:render(surface)

local text_button1 = sys.new_freetype(text_color, 30, {x=100,y=100}, utils.absolute_path("data/fonts/DroidSans.ttf"))
text_button1:draw_over_surface(surface,text)


event.remote_control:on("button_release", newMenu.load_view)

end
return newMenu







---------------------------------------------------------------------
--[[	local background_color = {r=0, g=0, b=0}
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))

	--creates some colors
	local button_color = {r=0, g=128, b=225}
	local button_color_select = {r=255,g=182,b=193}
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

	surface:fill(button_color_select, {width=500, height=100, x=100, y=50})
	text_button1:draw_over_surface(surface, "1. Numerical quiz")

	-- Implements Button 2. Multiple choice question
	surface:fill(button_color, {width=500, height=100, x=100, y=250})
	text_button2:draw_over_surface(surface, "2. Multiple choice question")

	-- Implements the exit button
	surface:fill(button_color, {width=500, height=100, x=100, y=450})
	text_button3:draw_over_surface(surface, "3. Exit")

	-- Testing Subsurface
	local sub_surface1 = subsurface(surface,{width=100, height=100, x=0, y=0})
	sub_surface1:clear({r=255, g=255, b=255, a=255})

	-- Instance remote control and mapps it to the buttons
	event.remote_control:on("button_release", menu.load_view)

end

return menu  ]]
