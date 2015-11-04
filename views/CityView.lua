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
local subsurface = require("lib.view.Subsurface")
local NumericalQuizView = require("views.NumericalQuizView")

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityView:__init(remote_control)
	View.__init(self)
	self.background_path = ""
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

	-- Testing Subsurface
	local sub_surface1 = subsurface(surface,{width=100, height=100, x=0, y=0})
	sub_surface1:clear({r=255, g=255, b=255, a=255})

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
		local numerical_quiz_view = NumericalQuizView()
		view.view_manager:set_view(numerical_quiz_view)
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