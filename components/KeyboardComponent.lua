local utils = require("lib.utils")
local event = require("lib.event")
local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local logger = require("lib.logger")
local button = require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")
local KeyboardComponent = class("KeyboardComponent", View)

KeyboardComponent.active = true
-- Constructor for SplashView
-- @param event_listener Remote control to listen to
function KeyboardComponent:__init(remote_control)
	View.__init(self)
	self.background_path = ""
	local button_color = color(0, 128, 225, 255)
	local text_color = color(55, 55, 55, 255)
	local score_text_color = color(255, 255, 255, 255)
	local color_selected = color(33, 99, 111, 255)
	local color_disabled = color(111, 222, 111, 255) --have not been used yet
	-- Instance of	all Buttons
	positions = {}
  --"www.jochentopf.com/email/chars.html"

	self.input_string = ""
	self.letters={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","x","y","z","@","-","_","1","2","3","4","5","6","7","8","9","0"}
	mx = 0
	my = 0

	self.button_size= {width=90,height=70}
	self.button_padding = 10
	self.nbr_of_buttons = {x=5, y=7}

	self.button_start_location = {left=((screen:get_width()/2)-(self.nbr_of_buttons["x"]*(self.button_size["width"]+self.button_padding)))/2, top=100}
	self.buttonGrid = button_grid()
	for i=1, self.nbr_of_buttons["x"]*self.nbr_of_buttons["y"] do
		local temp_button = button(
			 button_color,
			 color_selected,
			 color_disabled,
			 true,
			 false)

		positions[i] = {x=(self.button_start_location["left"]+((self.button_size["width"]+self.button_padding)*mx)),
		y=(self.button_start_location["top"]+((self.button_size["height"]+self.button_padding)*my))}

		-- temp_button:set_textdata(self.letters[i],text_color,
		-- {x=(self.button_start_location["left"]+((self.button_size["width"]+self.button_padding)*mx))+self.button_size["height"]/2,
		--  y=(self.button_start_location["top"]+((self.button_size["height"]+self.button_padding)*my))+self.button_size["height"]/4},
		--  self.button_size["height"]/2,utils.absolute_path("data/fonts/DroidSans.ttf"))



		mx = mx+1
		if (i%self.nbr_of_buttons["x"]==0) then
			mx = 0
			my = my+1
		end
		self.buttonGrid:add_button(positions[i],self.button_size,temp_button)
	end



end

function KeyboardComponent:render(surface)
  surface:fill({r=23, g=0, b=23}, {width=surface:get_width()/2, height=surface:get_height(), x=0, y=0})
	self.surface = surface


	self.buttonGrid:render(surface)

	mx = 0
	my = 0

	for i=1, self.nbr_of_buttons["x"]*self.nbr_of_buttons["y"] do
		local spoc = sys.new_freetype({r=255, g=255, b=255}, 32,
		{x=(self.button_start_location["left"]+((self.button_size["width"]+self.button_padding)*mx))+self.button_size["height"]/2,
		y=(self.button_start_location["top"]+((self.button_size["height"]+self.button_padding)*my))+self.button_size["height"]/4},
		utils.absolute_path("data/fonts/DroidSans.ttf"))
		spoc:draw_over_surface(screen, tostring(self.letters[i]))

		mx = mx+1
		if (i%self.nbr_of_buttons["x"]==0) then
			mx = 0
			my = my+1
		end
	end

	self.keyboard_position = self.buttonGrid.button_indicator


end

function KeyboardComponent:get_string()
	return self.input_string
end

function KeyboardComponent:new_input()
	self.input_string = ""
end

function KeyboardComponent:button_press(button)
  --logger:trace("button: " .. button)
	logger:trace("position: " .. self.keyboard_position)
	if button == "down" then
		if (self.keyboard_position+self.nbr_of_buttons["x"] <= #self.buttonGrid.button_list) then

			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position+self.nbr_of_buttons["x"]].button:select()
			self.keyboard_position = self.keyboard_position+self.nbr_of_buttons["x"]
			--self.buttonGrid:render(self.surface)
			self:render(self.surface)
			gfx.update()
		end
	elseif button == "up" then
		if (self.keyboard_position-self.nbr_of_buttons["x"] >= 1) then
			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position-self.nbr_of_buttons["x"]].button:select()
			self.keyboard_position = self.keyboard_position-self.nbr_of_buttons["x"]
			--self.buttonGrid:render(self.surface)
			self:render(self.surface)
			gfx.update()
		end
	elseif button == "right" then
		if (self.keyboard_position%self.nbr_of_buttons["x"] ~= 0) then
			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position+1].button:select()
			self.keyboard_position = self.keyboard_position+1
			--self.buttonGrid:render(self.surface)
			self:render(self.surface)
			gfx.update()
		end
	elseif button == "left" then
		if (self.keyboard_position%self.nbr_of_buttons["x"] ~= 1) then
			self.buttonGrid.button_list[self.keyboard_position].button:select(false)
			self.buttonGrid.button_list[self.keyboard_position-1].button:select()
			self.keyboard_position = self.keyboard_position-1
			--self.buttonGrid:render(self.surface)
			self:render(self.surface)
			gfx.update()
		end
	elseif button == "ok" then
		logger:trace("you have choosen:" .. self.letters[self.keyboard_position])
		self.input_string = self.input_string .. self.letters[self.keyboard_position]
		logger:trace("your string is:" .. self.input_string)
		self:trigger("character_input")

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
