--- Base class for CityView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CityView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local CityView = class("CityView", View)
local event = require("lib.event")
local utils = require("lib.utils")
local multiplechoice_quiz = require("views.multiplechoice_quiz")
local SubSurface = require("lib.view.SubSurface")
local NumericalQuizView = require("views.NumericalQuizView")

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityView:__init(remote_control)
	View.__init(self)
	self.background_path = ""
	self.profile={name="Mohammed", level=5, experience=300, cash=500}
	self.city={name="Paris"}
end

function CityView:render(surface)
	-- Resets the surface and draws the background
	local background_color = {r=0, g=0, b=0}
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))

	--creates some colors
	local button_color = {r=0, g=128, b=225}
	local text_color = {r=0, g=0, b=0}
	local score_text_color = {r=255, g=255, b=255}
	local menu_bar_color = {r=0, g=0, b=0, a=225}
	local status_bar_color = {r=0, g=0, b=0}
	local status_text_color = {r=255, g=255, b=255}

	-- Creates some images
	-- local coinsurface = gfx.new_surface(50,50)


	-- This makes a freetype to write with
	local text_button1 = sys.new_freetype(text_color, 30, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button2 = sys.new_freetype(text_color, 30, {x=200,y=280}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button3 = sys.new_freetype(text_color, 30, {x=200,y=480}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local score = sys.new_freetype(score_text_color, 40, {x=1010,y=170}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_name = sys.new_freetype(status_text_color, 25, {x=10, y=10}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_level = sys.new_freetype(status_text_color, 20, {x=200, y=15}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_experience = sys.new_freetype(status_text_color, 20, {x=440, y=15}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_cash = sys.new_freetype(status_text_color, 20, {x=surface:get_width()-100, y=15}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local city_name = sys.new_freetype(status_text_color, 25, {x=surface:get_width()/2, y=10}, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Shows menu bar
	surface:fill(menu_bar_color, {width=surface:get_width()/3, height=surface:get_height(), x=0, y=0})

	-- Implement status bar
	surface:fill(status_bar_color, {width=surface:get_width(), height=50, x=0, y=0})
	surface:fill(score_text_color, {width=150, height=30, x=285,y=10})
		if(self.profile.experience/500~=1) then
		surface:fill(status_bar_color, {width=math.ceil(148*(1-self.profile.experience/500)), height=28, x=434-148*(1-self.profile.experience/500), y=11})
	end

	profile_name:draw_over_surface(surface, self.profile.name)
	profile_level:draw_over_surface(surface, "Level: " .. self.profile.level)
	profile_experience:draw_over_surface(surface, self.profile.experience .. "/500")
	profile_cash:draw_over_surface(surface, self.profile.cash)
	city_name:draw_over_surface(surface, self.city.name)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/coinIcon.png")),nil, {x=surface:get_width()-145,y=10,width=30,height=30} )

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
	--event.remote_control:on("button_release", self:load_view)
	local callback = utils.partial(self.load_view, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		callback
		--utils.partial(self.load_view, self)
	)
end

function CityView:load_view(button)
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
	end
end

return CityView
