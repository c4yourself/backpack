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
	buttons = {}
	positions = {}
	letters={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","x","y","z","@","-","_","1","2","3","4","5","6","7","8","9","0"}
	mx = 0
	my = 0
	local button_start_location = {left=50, top=100}
	local button_size= {width=60,height=60}
	local button_padding = 10
	local nbr_of_buttons = {x=6, y=6}
	self.buttonGrid = button_grid()
	for i=1, nbr_of_buttons["x"]*nbr_of_buttons["y"] do
		buttons[i] = button(button_color, color_selected, color_disabled,true,true)
		positions[i] = {x=(button_start_location["left"]+((button_size["width"]+button_padding)*mx)), y=(button_start_location["top"]+((button_size["height"]+button_padding)*my))}
		buttons[i]:set_textdata(letters[i],text_color,{x=(button_start_location["left"]+((button_size["width"]+button_padding)*mx))+button_size["height"]/4, y=(button_start_location["top"]+((button_size["height"]+button_padding)*my))+button_size["height"]/4},button_size["height"]/2,utils.absolute_path("data/fonts/DroidSans.ttf"))
		mx = mx+1
		if (i%nbr_of_buttons["x"]==0) then
			mx = 0
			my = my+1
		end
		self.buttonGrid:add_button(positions[i],button_size,buttons[i])
	end

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
