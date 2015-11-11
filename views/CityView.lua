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
--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityView:__init(remote_control)
	View.__init(self)
	self.background_path = ""
	self.profile={name="Mohammed", level=5, experience=300, cash=500}
	self.city={name="Paris"}
	self.buttonGrid = button_grid(remote_control)

end

function CityView:render(surface)
	-- Creates local variables for height and width
	local height = surface:get_height()
	local width = surface:get_width()
	-- Resets the surface and draws the background
	local background_color = {r=0, g=0, b=0}
	surface:clear(background_color)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))

	--creates some colors
	local button_color = color(255, 99, 0, 255)
	local color_selected = color(255, 153, 0, 255)
	local color_disabled = color(111, 222, 111, 255) --have not been used yet
	local text_color = color(0, 0, 0,255)
	local score_text_color = color(255, 255, 255, 255)
	local menu_bar_color = color(0, 0, 0, 225)
	local status_bar_color = color(0, 0, 0, 255)
	local status_text_color = color(255, 255, 255, 255)
	local experience_bar_color = color(100, 100, 100, 255)

	-- Creates some images
	-- local coinsurface = gfx.new_surface(50,50)


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
  surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/coinIcon.png")),nil, {x=surface:get_width()-145,y=10,width=30,height=30} )

	local button_1 = button(button_color, color_selected, color_disabled,true,true)
	local button_2 = button(button_color, color_selected, color_disabled,true,false)
	local button_3 = button(button_color, color_selected, color_disabled,true,false)
	local button_4 = button(button_color, color_selected, color_disabled,true,false)
	local button_5 = button(button_color, color_selected, color_disabled,true,false)
	local button_6 = button(button_color, color_selected, color_disabled,true,false)
	local button_7 = button(button_color, color_selected, color_disabled,true,false)
	local button_8 = button(button_color, color_selected, color_disabled,true,false)

	-- Define each button's posotion and size
	local position_1={x=3*width/45,y=100}
	local button_size_1 = {width=4*width/45,height=4*width/45}

	local position_2={x=8*width/45,y=100}
	local button_size_2 = {width=4*width/45,height=4*width/45}

	local position_3={x=3*width/45,y=100+5*width/45}
	local button_size_3 = {width=4*width/45,height=4*width/45}

	local position_4={x=8*width/45,y=100+5*width/45}
	local button_size_4 = {width=4*width/45,height=4*width/45}

	local position_5={x=3*width/45,y=(height-50)/2+100}
	local button_size_5 = {width=4*width/45,height=4*width/45}

	local position_6={x=8*width/45,y=(height-50)/2+100}
	local button_size_6 = {width=4*width/45,height=4*width/45}

	local position_7={x=3*width/45,y=5*width/45+(height-50)/2+100}
	local button_size_7 = {width=4*width/45,height=4*width/45}

	local position_8={x=8*width/45,y=5*width/45+(height-50)/2+100}
	local button_size_8 = {width=4*width/45,height=4*width/45}

	-- Using the button grid to create buttons
	self.buttonGrid:add_button(position_1,button_size_1,button_1)
	self.buttonGrid:add_button(position_2,button_size_2,button_2)
	self.buttonGrid:add_button(position_3,button_size_3,button_3)
	self.buttonGrid:add_button(position_4,button_size_4,button_4)
	self.buttonGrid:add_button(position_5,button_size_5,button_5)
	self.buttonGrid:add_button(position_6,button_size_6,button_6)
	self.buttonGrid:add_button(position_7,button_size_7,button_7)
	self.buttonGrid:add_button(position_8,button_size_8,button_8)


  -- Insert text and its color, position, size, path for each button
  -- Button always has the screen as its background, not its subsurface
	--button_1:set_textdata("Numerical quiz",text_color,{x=100,y=50},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	--button_2:set_textdata("Multiple choice question",text_color,{x=100,y=250},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	--button_3:set_textdata("Exit",text_color,{x=100,y=450},30,utils.absolute_path("data/fonts/DroidSans.ttf"))

 -- Adding the score to surface
	local score = sys.new_freetype(score_text_color:to_table(), 40, {x=1010,y=170}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	score:draw_over_surface(surface, "Score: " .. "125")

  -- using the button grid to render all buttons and texts
	self.buttonGrid:render(surface)
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/GeoIcon.png")),nil, {x=position_1.x,y=position_1.y,width=button_size_1.width,height=button_size_1.height} )

  -- testing the subsurface
	--local sub_surface1 = SubSurface(surface,{width=100, height=100, x=0, y=0})
	--sub_surface1:clear({r=255, g=255, b=255, a=255})



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
