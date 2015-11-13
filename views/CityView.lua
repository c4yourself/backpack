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
local button= require("lib.components.Button")
local button_grid=require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")
local CityTourView = require("views.CityTourView")
local TravelView = require("views.TravelView")
local subSurface = require("lib.view.SubSurface")

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityView:__init(remote_control)
	View.__init(self)
	self.background_path = ""
	self.profile = {name = "Mohammed", level = 5, experience = 300, cash = 500}
	self.city = {name = "Paris"}
	self.buttonGrid = button_grid(remote_control)

	-- Create som button colors
	local button_color = color(255, 99, 0, 255)
	local color_selected = color(255, 153, 0, 255)
	local color_disabled = color(111, 222, 111, 255) --have not been used yet
	local city_view_selected_color = color(0, 0, 0, 50)
	local city_view_color = color(0, 0, 0, 0)

	-- Creates local variables for height and width
	local height = screen:get_height()
	local width = screen:get_width()

	-- Add buttons
	local button_1 = button(button_color, color_selected, color_disabled,true,true)
	local button_2 = button(button_color, color_selected, color_disabled,true,false)
	local button_3 = button(button_color, color_selected, color_disabled,true,false)
	local button_4 = button(button_color, color_selected, color_disabled,true,false)
	local button_5 = button(button_color, color_selected, color_disabled,true,false)
	local button_6 = button(button_color, color_selected, color_disabled,true,false)
	local button_7 = button(button_color, color_selected, color_disabled,true,false)
	local button_8 = button(button_color, color_selected, color_disabled,true,false)
	local city_tour_button = button(city_view_color, city_view_selected_color, color_disabled, true, false)

	-- Define each button's posotion and size
	local button_size = {width = 4*width/45, height = 4*width/45}
	local position_1 = {x = 3*width/45, y = 100}
	local position_2 = {x = 8*width/45, y = 100}
	local position_3 = {x = 3*width/45, y = 100+5*width/45}
	local position_4 = {x = 8*width/45, y = 100+5*width/45}
	local position_5 = {x = 3*width/45, y = (height-50)/2+100}
	local position_6 = {x = 8*width/45, y = (height-50)/2+100}
	local position_7 = {x = 3*width/45, y = 5*width/45+(height-50)/2+100}
	local position_8 = {x = 8*width/45, y = 5*width/45+(height-50)/2+100}
	local city_tour_position = {x = width/3, y = 50}
	local city_tour_size = {width = 2*width/3-1, height = height-51}

	-- Using the button grid to create buttons
	self.buttonGrid:add_button(position_1, button_size, button_1)
	self.buttonGrid:add_button(position_2, button_size, button_2)
	self.buttonGrid:add_button(position_3, button_size, button_3)
	self.buttonGrid:add_button(position_4, button_size, button_4)
	self.buttonGrid:add_button(position_5, button_size, button_5)
	self.buttonGrid:add_button(position_6, button_size, button_6)
	self.buttonGrid:add_button(position_7, button_size, button_7)
	self.buttonGrid:add_button(position_8, button_size, button_8)
	self.buttonGrid:add_button(city_tour_position, city_tour_size, city_tour_button)

	local button_callback = function()
		self:render(screen)
		gfx.update()
	end
	self:listen_to(
		self.buttonGrid,
		"dirty",
		button_callback
	)
	local callback = utils.partial(self.load_view, self)
	self:listen_to(
	event.remote_control,
	"button_release",
	callback
	)

end

function CityView:render(surface)
-- Creates local variables for height and width
local height = surface:get_height()
local width = surface:get_width()
	-- Resets the surface and draws the background
	local background_color = {r = 0, g = 0, b = 0}

	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/Paris.png")))


	--creates some colors
	local text_color = color(0, 0, 0,255)
	local score_text_color = color(255, 255, 255, 255)
	local menu_bar_color = color(0, 0, 0, 225)
	local status_bar_color = color(0, 0, 0, 255)
	local status_text_color = color(255, 255, 255, 255)
	local experience_bar_color = color(100, 100, 100, 255)

	-- This makes a freetype to write with
	local text_button1 = sys.new_freetype(text_color, 30, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button2 = sys.new_freetype(text_color, 30, {x=200,y=280}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button3 = sys.new_freetype(text_color, 30, {x=200,y=480}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_name = sys.new_freetype(status_text_color, 25, {x=10, y=10}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_level = sys.new_freetype(status_text_color, 20, {x=200, y=15}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_experience = sys.new_freetype(status_text_color, 20, {x=440, y=15}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local profile_cash = sys.new_freetype(status_text_color, 20, {x=width-100, y=15}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local city_name = sys.new_freetype(status_text_color, 25, {x=width/2, y=10}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local mini_games = sys.new_freetype(status_text_color, 25, {x=width/6-65, y=60}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local options = sys.new_freetype(status_text_color, 25, {x=width/6-45, y=(height-50)/2+60}, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Shows menu bar
	surface:fill(menu_bar_color, {width=width/3, height=height-50, x=0, y=50})
	mini_games:draw_over_surface(surface, "Mini Games")
	options:draw_over_surface(surface, "Options")

	-- Implement status bar
	surface:fill(status_bar_color, {width=width, height=50, x=0, y=0})
	surface:fill(score_text_color, {width=150, height=30, x=285,y=10})
		if(self.profile.experience/500~=1) then
		surface:fill(experience_bar_color, {width=math.ceil(148*(1-self.profile.experience/500)), height=28, x=434-148*(1-self.profile.experience/500), y=11})
	end

	profile_name:draw_over_surface(surface, self.profile.name)
	profile_level:draw_over_surface(surface, "Level: " .. self.profile.level)
	profile_experience:draw_over_surface(surface, self.profile.experience .. "/500")
	profile_cash:draw_over_surface(surface, self.profile.cash)
	city_name:draw_over_surface(surface, self.city.name)
  surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/coinIcon.png")), nil, {x = surface:get_width()-145, y = 10, width = 30, height = 30} )

  -- using the button grid to render all buttons and texts
	self.buttonGrid:render(surface)
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
	elseif button == "5" then
		local city_tour_view = SubSurface(screen,{width=screen:get_width()*0.9, height=(screen:get_height()-50)*0.9, x=screen:get_width()*0.05, y=screen:get_height()*0.05+50})
		CityTourView:render(city_tour_view)
		gfx.update()

	elseif button == "9" then
		local travel_view = SubSurface(screen,{width=screen:get_width()*0.9, height=(screen:get_height()-50)*0.9, x=screen:get_width()*0.05, y=screen:get_height()*0.05+50})
		TravelView:render(travel_view)
		gfx.update()
	end


end

return CityView
