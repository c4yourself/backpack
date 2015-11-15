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
	self.surface = surface

	-- Instance of	all Buttons
	positions = {}
  --"www.jochentopf.com/email/chars.html"
		
	self.letters={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","x","y","z","@","-","_","1","2","3","4","5","6","7","8","9","0"}
	mx = 0
	my = 0

	local button_size= {width=90,height=70}
	local button_padding = 10
	self.nbr_of_buttons = {x=5, y=7}

	local button_start_location = {left=((surface:get_width()/2)-(self.nbr_of_buttons["x"]*(button_size["width"]+button_padding)))/2, top=100}
	self.buttonGrid = button_grid()
	for i=1, self.nbr_of_buttons["x"]*self.nbr_of_buttons["y"] do
		local temp_button = button(button_color, color_selected, color_disabled,true,false)
		positions[i] = {x=(button_start_location["left"]+((button_size["width"]+button_padding)*mx)), y=(button_start_location["top"]+((button_size["height"]+button_padding)*my))}
		temp_button:set_textdata(self.letters[i],text_color,{x=(button_start_location["left"]+((button_size["width"]+button_padding)*mx))+button_size["height"]/2, y=(button_start_location["top"]+((button_size["height"]+button_padding)*my))+button_size["height"]/4},button_size["height"]/2,utils.absolute_path("data/fonts/DroidSans.ttf"))

		mx = mx+1
		if (i%self.nbr_of_buttons["x"]==0) then
			mx = 0
			my = my+1
		end
		self.buttonGrid:add_button(positions[i],button_size,temp_button)
	end
	self.buttonGrid:render(surface)

	self.keyboard_position = self.buttonGrid.button_indicator
end

function KeyboardComponent:button_press(button)
  --logger:trace("button: " .. button)
	--logger:trace("position: " .. self.keyboard_position)
	if button == "down" then
		if (self.keyboard_position+self.nbr_of_buttons["x"] <= #self.buttonGrid.button_list) then
			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position+self.nbr_of_buttons["x"]].button:select()
			self.keyboard_position = self.keyboard_position+self.nbr_of_buttons["x"]
			self.buttonGrid:render(self.surface)
			gfx.update()
		end
	elseif button == "up" then
		if (self.keyboard_position-self.nbr_of_buttons["x"] >= 1) then
			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position-self.nbr_of_buttons["x"]].button:select()
			self.keyboard_position = self.keyboard_position-self.nbr_of_buttons["x"]
			self.buttonGrid:render(self.surface)
			gfx.update()
		end
	elseif button == "right" then
		if (self.keyboard_position%self.nbr_of_buttons["x"] ~= 0) then
			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position+1].button:select()
			self.keyboard_position = self.keyboard_position+1
			self.buttonGrid:render(self.surface)
			gfx.update()
		end
	elseif button == "left" then
		if (self.keyboard_position%self.nbr_of_buttons["x"] ~= 1) then
			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position-1].button:select()
			self.keyboard_position = self.keyboard_position-1
			self.buttonGrid:render(self.surface)
			gfx.update()
		end
	elseif button == "ok" then
		logger:trace("you have choosen:" .. self.letters[self.keyboard_position])
	end
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
