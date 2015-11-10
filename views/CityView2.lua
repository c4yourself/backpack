--- Base class for CityView2
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CityView2

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local CityView2 = class("CityView2", View)
local event = require("lib.event")
local utils = require("lib.utils")
local multiplechoice_quiz = require("views.multiplechoice_quiz")
local SubSurface = require("lib.view.SubSurface")
local NumericalQuizView = require("views.NumericalQuizView")
local button= require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityView2:__init(remote_control)
	View.__init(self)
	self.background_path = ""
end

function CityView2:render(surface)
	-- Resets the surface and draws the background
	local background_color = {r=0, g=0, b=0}
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))

	--creates some colors
	local button_color = color(0, 128, 225, 255)
	local text_color = color(55, 55, 55, 255)
	local score_text_color = color(255, 255, 255, 255)
	local color_selected = color(33, 99, 111, 255)
	local color_disabled = color(111, 222, 111, 255) --have not been used yet

	-- Instance of	all Buttons
	local button_1 = button(button_color, color_selected, color_disabled,true,true)
	local button_2 = button(button_color, color_selected, color_disabled,true,false)
	local button_3 = button(button_color, color_selected, color_disabled,true,false)

 -- Define each button's posotion and size
	local position_1={x=100,y=50}
	local button_size_1 = {width=500,height=100}

	local position_2={x=100,y=250}
	local button_size_2 = {width=500,height=100}

	local position_3={x=100,y=450}
	local button_size_3 = {width=500,height=100}

	-- create a button grid for the current view,
	-- for managing all buttons' layout and states
	self.buttonGrid = button_grid()

	-- Using the button grid to create buttons
	self.buttonGrid:add_button(position_1,button_size_1,button_1)
	self.buttonGrid:add_button(position_2,button_size_2,button_2)
	self.buttonGrid:add_button(position_3,button_size_3,button_3)

	-- Insert text and its color, position, size, path for each button
	-- Button always has the screen as its background, not its subsurface
	button_1:set_textdata("Numerical quiz",text_color,{x=100,y=50},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_2:set_textdata("Multiple choice question",text_color,{x=100,y=250},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_3:set_textdata("Exit",text_color,{x=100,y=450},30,utils.absolute_path("data/fonts/DroidSans.ttf"))

 -- Adding the score to surface
	local score = sys.new_freetype(score_text_color:to_table(), 40, {x=1010,y=170}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	score:draw_over_surface(surface, "Score: " .. "125")

	-- using the button grid to render all buttons and texts
	self.buttonGrid:render(surface)

	-- testing the subsurface
	local subsurface1 = SubSurface(surface,{width=100, height=100, x=0, y=0})
	subsurface1:clear({r=255, g=255, b=255, a=255})

	-- Instance remote control and mapps it to the buttons
	--event.remote_control:on("button_release", self:load_view)
	local callback = utils.partial(self.load_view, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		callback
		--utils.partial(self.load_view, self)
	)
end

function CityView2:load_view(button)
	if button == "1" then
		--Instanciate a numerical quiz
		local numerical_quiz_view = NumericalQuizView()
		--Stop listening to everything
		-- TODO
		-- Start listening to the exit event, which is called when the user
		-- exits a quiz
		local callback = function()
			utils.partial(view.view_manager.set_view, view.view_manager)(self)
			gfx.update()
		end
		self:listen_to(
			numerical_quiz_view,
			"exit",
			--view.view_manager:set_view(self)
			callback
		)
		--Update the view
		numerical_quiz_view:render(screen)
		-- TODO This should be done by a subsurface in the final version
		gfx.update()
	elseif button == "2" then
		multiplechoice_quiz.render(screen)
		gfx.update()
	elseif button == "3" then
		print("Shut down program")
		sys.stop()

	elseif button == "down" then
		-- the indicator refers to the selecting button
		local indicator = self.buttonGrid.button_indicator
		local button_list = self.buttonGrid.button_list

		indicator = indicator % #button_list
		indicator = indicator + 1
		button_list[indicator].button:select(true)

		 if indicator == 1 then
		 button_list[#button_list].button:select(false)
	 else
			button_list[indicator-1].button:select(false)
	 end

		self.buttonGrid.button_indicator = indicator

		self.buttonGrid:render(screen)
		gfx.update()

	elseif button == "up" then
		local indicator = self.buttonGrid.button_indicator
		local button_list = self.buttonGrid.button_list

		indicator = indicator - 1

		if indicator == 0 then
		indicator = #button_list
		end

		button_list[indicator].button:select(true)

		if indicator == #button_list then
		button_list[1].button:select(false)
		else
		button_list[indicator+1].button:select(false)
		end

		self.buttonGrid.button_indicator = indicator
		self.buttonGrid:render(screen) --use the view's button grid for rendering

		gfx.update()

	elseif button == "ok" then
	--TODO able to enter the current pointing button

	end
end

return CityView2
