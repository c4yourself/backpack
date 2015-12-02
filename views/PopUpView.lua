local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local button_grid	=	require("lib.components.ButtonGrid")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local serpent = require("lib.serpent")
local Button = require("lib.components.Button")
local Profile = require("lib.profile.Profile")

local PopUp = class("PopUp",View)

function PopUp:__init(remote_control,surface, type, message)
	View:__init(self)
	self.popup_button_grid = button_grid(remote_control)
	self:add_view(self.popup_button_grid)

	self.width = screen:get_width() * 0.5
	self.height = screen:get_height() * 0.5
	self.message = message
	local text_height = 50
	self.message_font_height = 18

	self.type = type
	self.message_head_font = Font("data/fonts/DroidSans.ttf",20, Color(0,0,0,255))
	self.message_font = Font("data/fonts/DroidSans.ttf",self.message_font_height, Color(0,0,0,255))
	self.button_font = Font("data/fonts/DroidSans.ttf",25, Color(0,0,0,255))
	local indent = 55
	-- Create buttons positions and size
	self.button_size = {width=self.width*0.22, height=self.height*0.15}
	--4*(width-indent)/27, height=4*(height-1)/13}

	--self.button_size = {width = 100, height = 100}
	self.button_color = Color(255,90,0,255)
	self.color_selected = Color(255,153,0,255)
	self.color_disabled = Color(0,0,0,255)
	self.text_color = Color(255,255,255,255)

	if self.type == "message" then
		self:_create_message_buttons()
	else
		self:_create_confirmation_buttons()
	end


	local callback = utils.partial(self.load_view, self)
	self:listen_to(
	event.remote_control,
	"button_release",
	callback
	)

	local button_callback = function()
		self.popup_button_grid:render(surface)
		gfx.update()
	end

	local button_click = function(button)
		if button.transfer_path == "button_confirmation" then
--			self:trigger("exit_view")
			self:trigger("button_click", "ok")
		elseif button.transfer_path == "button_cancel" then
			self:trigger("button_click", "cancel")
		else
			self:trigger("button_click", "ok")
		end


	end

	--might be a problem with this?
	self:listen_to(
		self.popup_button_grid,
		"dirty",
		button_callback
		)

	self:listen_to(
			self.popup_button_grid,
			"button_click",
			button_click
	)
end


function PopUp:_create_message_buttons()
	button_ok = Button(self.button_color,self.color_selected,self.color_disabled,true,true, "button_ok")
	button_ok:set_textdata("Ok",self.text_color, {x=200, y=200},20, "data/fonts/DroidSans.ttf")
	self.popup_button_grid:add_button({x = self.width*0.4, y = self.height*0.7}, self.button_size, button_ok)
end


function PopUp:_create_confirmation_buttons()
	local button_confirmation = Button(self.button_color,self.color_selected,self.color_disabled,true,true, "button_confirmation")
	local button_cancel = Button(self.button_color,self.color_selected,self.color_disabled,true,false, "button_cancel")
	button_confirmation:set_textdata("Confirm",self.text_color, {x=200, y=200},20, "data/fonts/DroidSans.ttf")
	button_cancel:set_textdata("Cancel",self.text_color, {x=200, y=200},20, "data/fonts/DroidSans.ttf")

	self.popup_button_grid:add_button({x = self.width*0.2, y = self.height*0.7}, self.button_size, button_confirmation)
	self.popup_button_grid:add_button({x = self.width*0.55, y = self.height*0.7}, self.button_size, button_cancel)

end

function PopUp:render(surface)
	surface:fill({r=255, g=255, b=255, a=255})

	local height = surface:get_height()
	local width = surface:get_width()
	local text_indent = 100 -- Indents text area
	local first_line_pos = self.height * 0.2
	local message_line_pos = first_line_pos + 30

	-- Draw the fonts
	--self.message_head_font:draw(surface, {x = self.width * 0.44, y = self.height * 0.08}, "Message")

	surface:fill({0,0,0,255}, {width = self.width * 0.5, height = 2, x =self.width * 0.25, y = first_line_pos})
	--self. message_table = {text = "Are you sure you want to exit?"}
	local len = string.len(self.message[1])
	local half_len = len / 2
	local percent = len / self.width
	--self.message_font:draw(surface, {x = self.width * 0.5 - len*4, y=self.height * 0.3}, self.message.text)

	for i, text in ipairs(self.message) do
		--local text_width= width*2/3-2*text_indent
		local len = string.len(self.message[i])
		local half_len = len / 2
		local percent = len / self.width
		self.message_font:draw(surface, {x = self.width * 0.5 - len*4, y=message_line_pos}, self.message[i])
		message_line_pos = message_line_pos + self.message_font_height + 5
		--city_tour_text:draw(surface, {x = width/3+text_indent, y = 50+25*i, width = text_width, height = 25}, text, nil, nil)
	end


	surface:fill({0,0,0,255}, {width = self.width * 0.5, height = 2, x = self.width * 0.25, y = message_line_pos + 30})

--	city_tour_attraction_font:draw(surface, {x = height/6, y = height*23/30+5, width = height*0.54*3/5, height = 30}, "Message2", center)

	-- Draw tour text square x-axis
	--surface:fill({0,0,0,255}, {width = 2/3*width-150, height = 2, x = width/3+95, y =45})

	--Write all the tour text
	--city_tour_text:draw(surface, {x = width/3+text_indent, y = 50+25*i, width = text_width, height = 25}, "hej", nil, nil)

	--Render buttons
	self.popup_button_grid:render(surface)
	--self:trigger("exit_view")
end

function PopUp:load_view(button)

	if button == "back" then
	self:trigger("exit_view")
		--Stop listening to everything
		-- TODO
		-- Start listening to the exit

	end
end

-- function PopUp:destroy()
-- 	view.View.destroy(self)
-- 	--self.tour_attraction_image:destroy()
-- end

return PopUp
