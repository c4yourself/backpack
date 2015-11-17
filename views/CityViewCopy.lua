--- Base class for CityView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CityView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local CityViewCopy = class("CityViewCopy", View)
local event = require("lib.event")
local utils = require("lib.utils")
local travel_view = require("views.TravelView")
local SubSurface = require("lib.view.SubSurface")
local NumericalQuizView = require("views.NumericalQuizView")

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityViewCopy:__init(remote_control)
	View.__init(self)
	self.background_path = ""
	tv = travel_view(remote_control)
end

function CityViewCopy:render(surface)
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
	text_button2:draw_over_surface(surface, "2. Travel View")

	-- Implements the exit button
	surface:fill(button_color, {width=500, height=100, x=100, y=450})
	text_button3:draw_over_surface(surface, "3. Exit")

	-- Testing Subsurface
	local sub_surface1 = SubSurface(surface,{width=100, height=100, x=0, y=0})
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

function CityViewCopy:load_view(button)
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

		local sub_surface_travel_view = SubSurface(screen,{width=screen:get_width()*0.86, height=screen:get_height()*0.9-100*0.9, x=screen:get_width()*0.04, y=screen:get_height()*0.05+50})

		tv:render(sub_surface_travel_view)
		gfx.update()

	elseif button == "3" then
		print("Shut down program")
		sys.stop()
	end
end

return CityViewCopy
