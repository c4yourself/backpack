local utils = require("lib.utils")
local event = require("lib.event")
local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local KeyboardComponent = class("KeyboardComponent", View)
local logger = require("lib.logger")
local button = require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")

KeyboardComponent.active = true
-- Constructor for SplashView
-- @param event_listener Remote control to listen to
function KeyboardComponent:__init(remote_control)
	View.__init(self)
	self.background_path = ""
end

function KeyboardComponent:render(surface)
  surface:fill({r=23, g=0, b=23}, {width=surface:get_width()/2, height=surface:get_height(), x=0, y=0})
	local button_color = color(0, 128, 225, 255)
	local text_color = color(55, 55, 55, 255)
	local score_text_color = color(255, 255, 255, 255)
	local color_selected = color(33, 99, 111, 255)
	local color_disabled = color(111, 222, 111, 255) --have not been used yet

	-- Instance of	all Buttons
	local button_1 = button(button_color, color_selected, color_disabled,true,true)
	local button_2 = button(button_color, color_selected, color_disabled,true,false)
	local button_3 = button(button_color, color_selected, color_disabled,true,false)
	local button_4 = button(button_color, color_selected, color_disabled,true,false)
	local button_5 = button(button_color, color_selected, color_disabled,true,false)
	local button_6 = button(button_color, color_selected, color_disabled,true,false)
	local button_7 = button(button_color, color_selected, color_disabled,true,false)
	local button_8 = button(button_color, color_selected, color_disabled,true,false)
	local button_9 = button(button_color, color_selected, color_disabled,true,false)

 -- Define each button's posotion and size
	local position_1={x=50,y=50}
	local button_size= {width=50,height=50}
	local position_2={x=110,y=50}
	local position_3={x=170,y=50}
	local position_4={x=50,y=110}
	local position_5={x=110,y=110}
	local position_6={x=170,y=110}
	local position_7={x=50,y=170}
	local position_8={x=110,y=170}
	local position_9={x=170,y=170}

	-- create a button grid for the current view,
	-- for managing all buttons' layout and states
	self.buttonGrid = button_grid()

	-- Using the button grid to create buttons
	self.buttonGrid:add_button(position_1,button_size,button_1)
	self.buttonGrid:add_button(position_2,button_size,button_2)
	self.buttonGrid:add_button(position_3,button_size,button_3)
	self.buttonGrid:add_button(position_4,button_size,button_4)
	self.buttonGrid:add_button(position_5,button_size,button_5)
	self.buttonGrid:add_button(position_6,button_size,button_6)
	self.buttonGrid:add_button(position_7,button_size,button_7)
	self.buttonGrid:add_button(position_8,button_size,button_8)
	self.buttonGrid:add_button(position_9,button_size,button_9)

	-- Insert text and its color, position, size, path for each button
	-- Button always has the screen as its background, not its subsurface
	button_1:set_textdata("a",text_color,{x=60,y=60},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_2:set_textdata("b",text_color,{x=120,y=60},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_3:set_textdata("c",text_color,{x=180,y=60},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_4:set_textdata("d",text_color,{x=60,y=120},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_5:set_textdata("e",text_color,{x=120,y=120},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_6:set_textdata("f",text_color,{x=180,y=120},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_7:set_textdata("g",text_color,{x=60,y=180},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_8:set_textdata("h",text_color,{x=120,y=180},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_9:set_textdata("i",text_color,{x=180,y=180},30,utils.absolute_path("data/fonts/DroidSans.ttf"))

	self.buttonGrid:render(surface)
end

function KeyboardComponent:button_press(button)
  logger:trace("button: " .. button)
end

function KeyboardComponent:set_active(active)
	if(active == false) then
		logger:trace("keyboard is set: INACTIVE")
	else
		logger:trace("keyboard is set: ACTIVE")
	end
  KeyboardComponent.active = active
end

function KeyboardComponent:is_active()
  return KeyboardComponent.active
end




return KeyboardComponent
