local class = require("lib.classy")
local utils = require("lib.utils")
local event = require("lib.event")
local SubSurface = require("lib.view.SubSurface")
local view = require("lib.view")
local View = require("lib.view.View")
local profile_selection = class("profile_selection", View)
--local profile_selection = {}

local profile_list = {"MaxiStormarknad","Bingoberra","Eivar","Skumtomte_90", "D4ngerBoi390KickflippingRainbow"}
local choice_index = 0 --Zero indexing over profile_list

function profile_selection:__init()
	View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

	-- Flags
	--Flags to determine whether a quiz or a question is answered
	self.listening_initiated = false
	--Components
	--Instanciate a numerical input component and make the quiz listen for changes
	-- Logic
	-- Associate a quiz instance with the View
	-- User input
	--self.user_answer = ""

	-- Graphics
	self.font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Listeners and callbacks
	self:listen_to(
		event.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

function profile_selection:get_profile()
	return profile_list[choice_index+1]
end

function profile_selection:press(key)
	if key == "right" then
	--TODO navigate to right side menu
	elseif key == "down" then
		if choice_index + 1 > #profile_list-1 then
			choice_index = 0
		else
			choice_index = choice_index + 1
		end
		self:trigger("dirty")
	elseif key == "up" then
		if choice_index - 1 < 0 then
			choice_index = #profile_list-1
		else
			choice_index = choice_index - 1
		end
		self:trigger("dirty")
	elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
	end
end

function profile_selection.load_view(button)
	if button == "1" then
	--	local numerical_quiz_view = NumericalQuizView()
	--	view.view_manager:set_view(numerical_quiz_view)
		gfx.update()
	elseif button == "2" then
	--	multiplechoice_quiz.render(screen)
		gfx.update()
	elseif button == "3" then
		print("Shut down program")
		sys.stop()
  end
end

local list =  {"MaxiStormarknad","Bingoberra","Eivar","Skumtomte_90", "D4ngerBoi390KickflippingRainbow"} -- put contents of the scroll frame here, for example item names
local buttons = {}

-- This functions renders the menu view
function profile_selection.render(surface)
	-- Resets the surface and draws the background
	local background_color = {r=124, g=130, b=255}
	surface:clear(background_color)
	--surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris_old.png")))

	--creates some colors
	local button_color = {r=0, g=128, b=225}
	local button_color_select = {r=255,g=182,b=193}
	local text_color = {r=0, g=0, b=0}
	local score_text_color = {r=255, g=255, b=255}

	local counter = 1
	local diff_y = 80--200

  for key,value in pairs(profile_list) do --foreach Profile
    print(profile_list[key])

		local text_button = sys.new_freetype(text_color, 30, {x=200,y=(200-choice_index*diff_y+diff_y*counter)}, utils.absolute_path("data/fonts/DroidSans.ttf"))

		if counter == 1 then
			surface:fill(button_color_select, {width=500, height=100, x=100, y=(250)})
		end
		text_button:draw_over_surface(surface, profile_list[key])

		buttons[counter]= text_button
		counter=counter+1
  end

	-- Testing Subsurface
	local sub_surface1 = SubSurface(surface,{width=600, height=100, x=0, y=0})
	sub_surface1:clear({r=27, g=146, b=38, a=50})

	local select_profile_label = sys.new_freetype(score_text_color, 40, {x=50,y=20}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	select_profile_label:draw_over_surface(surface, "Select Profile:")

	-- Implements Button 1. Numerical



	-- Implements Button 2. Multiple choice question
	--surface:fill(button_color, {width=500, height=100, x=100, y=250})
	--text_button2:draw_over_surface(surface, "2. ????")

	-- Implements the exit button
	--surface:fill(button_color, {width=500, height=100, x=100, y=450})
	--text_button3:draw_over_surface(surface, "3. PROFIT")



	-- Instance remote control and mapps it to the buttons
	--event.remote_control:on("button_release", profile_selection.load_view)
end

return profile_selection
