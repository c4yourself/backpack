local utils = require("lib.utils")
local event = require("lib.event")
local class = require("lib.classy")
local View = require("lib.view.View")
local Font = require("lib.draw.Font")
local view = require("lib.view")
local logger = require("lib.logger")
local color = require("lib.draw.Color")
local SubSurface = require("lib.view.SubSurface")
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
	self.lower_case={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","x","y","z","@","-","_",".","1","2","3","4","5","6","7","8","9","0","<-","ABC","OK"}
	self.upper_case={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","Y","Z","@","-","_",".","1","2","3","4","5","6","7","8","9","0","<-","abc","OK"}

	self.letters =self.lower_case

	mx = 0
	my = 0

	self.x_pointer = 0
	self.y_pointer = 0

	self.font_key = Font("data/fonts/DroidSans.ttf", 32, color(255, 255, 255, 255))

	self.button_size= {width=90,height=70}
	self.button_padding = 10
	self.nbr_of_buttons = {x=6, y=7}

	self.button_start_location = {left=((screen:get_width()/2)-(self.nbr_of_buttons["x"]*(self.button_size["width"]+self.button_padding)))/2, top=100}


	--self.buttonGrid = button_grid()
	for i=1, self.nbr_of_buttons["x"]*self.nbr_of_buttons["y"] do


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
		--self.buttonGrid:add_button(positions[i],self.button_size,temp_button)
	end
end

function KeyboardComponent:get_marked_letter()
	return self.letters[(self.nbr_of_buttons["x"]*(self.y_pointer))+self.x_pointer+1]
end

function KeyboardComponent:render(surface)
  surface:fill({r=23, g=0, b=23}, {width=surface:get_width()/2, height=surface:get_height(), x=0, y=0})
	self.surface = surface

	mx = 0
	my = 0

	for i=1, self.nbr_of_buttons["x"]*self.nbr_of_buttons["y"] do

		if self.x_pointer==mx and self.y_pointer==my then
			self.marker = SubSurface(surface,{width=self.button_size["width"],
																			height=self.button_size["height"],
																			x=(self.button_start_location["left"]+((self.button_size["width"]+self.button_padding)*mx)),
																			y=(self.button_start_location["top"]+((self.button_size["height"]+self.button_padding)*my))})
		self.marker:clear({r=250, g=105, b=0})
		end

		--spoc:draw_over_surface(screen, tostring(self.letters[i]))
		self.font_key:draw(surface, {x=(self.button_start_location["left"]+((self.button_size["width"]+self.button_padding)*mx+35)),
		y=(self.button_start_location["top"]+((self.button_size["height"]+self.button_padding)*my+16))}, self.letters[i])


		mx = mx+1
		if (i%self.nbr_of_buttons["x"]==0) then
			mx = 0
			my = my+1
		end
	end

	--self.keyboard_position = self.buttonGrid.button_indicator


end

function KeyboardComponent:get_string()
	return self.input_string
end

function KeyboardComponent:new_input(text)
	self.x_pointer = 0
	self.y_pointer = 0
	self.input_string = text
end

function KeyboardComponent:button_press(button)
	if button == "down" then
		if self.y_pointer + 1 >  self.nbr_of_buttons["y"] - 1 then
			self.y_pointer = 0
		else
			self.y_pointer = self.y_pointer+1
		end

		self:render(self.surface)
		gfx.update()
	elseif button == "up" then
		if self.y_pointer - 1 <  0  then
			self.y_pointer = self.nbr_of_buttons["y"] - 1
		else
			self.y_pointer = self.y_pointer - 1
		end

		self:render(self.surface)
		gfx.update()
	elseif button == "right" then
		if self.x_pointer + 1 >  self.nbr_of_buttons["x"] - 1 then
			self.x_pointer = 0
		else
			self.x_pointer = self.x_pointer+1
		end

		self:render(self.surface)
		gfx.update()
	elseif button == "left" then
		if self.x_pointer - 1 <  0  then
			self.x_pointer = self.nbr_of_buttons["x"] - 1
		else
			self.x_pointer = self.x_pointer - 1
		end

		self:render(self.surface)
		gfx.update()
	elseif button == "ok" then
		logger.trace("you have choosen:" .. self:get_marked_letter())
		if self:get_marked_letter()=="OK" then
			--Return to prev. No keyboard active
			self:trigger("exit")
		elseif self:get_marked_letter() == "<-" then
			--Remove latest
			self.input_string = string.sub(self.input_string, 1, #self.input_string-1)
		elseif self:get_marked_letter() == "ABC" then
			self.letters= self.upper_case
			self:render(self.surface)
			gfx.update()
		elseif self:get_marked_letter() == "abc" then
			self.letters= self.lower_case
			self:render(self.surface)
			gfx.update()
		else
			self.input_string = self.input_string .. self:get_marked_letter()
		end

		self:trigger("update")
	end
end

function KeyboardComponent:set_active(active)
	if(active == false) then
		logger.trace("keyboard is set: INACTIVE")
		--self.buttonGrid:blur()
	else
		logger.trace("keyboard is set: ACTIVE")
		--self.buttonGrid:focus()
	end
  KeyboardComponent.active = active
end

function KeyboardComponent:is_active()
  return KeyboardComponent.active
end




return KeyboardComponent
