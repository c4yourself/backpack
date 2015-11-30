--- Base class for CreateProfileView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CreateProfileView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local utils = require("lib.utils")
local SubSurface = require("lib.view.SubSurface")
local button= require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local InputField	=	require("components.InputField")
local BinaryButton	=	require("components.BinaryButton")
local color = require("lib.draw.Color")
local logger = require("lib.logger")
local KeyboardComponent	=	require("components.KeyboardComponent")

local CreateProfileView = class("CreateProfileView", View)

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CreateProfileView:__init(remote_control)
	View.__init(self)
	self.background_path = ""
	input_field = InputField("Name:", {x = 700, y = 80}, true)
	input_field2 = InputField("Mail:", {x = 700, y = 230}, false)
	input_field3 = InputField("Age:", {x = 700, y = 380}, false)
	binary_button = BinaryButton("Sex:", "female", "male", {x = 700, y = 530}, false)
	self.active_field = input_field

	self.background_color = {r=30, g=35, b=35}

	self.render_ticket = false

	self.hasActiveKeyboard = false
	self.keyboard = KeyboardComponent()
	self.keyboard:set_active(false)

	local update_string_callback = function()
		self.active_field:set_text(self.keyboard.input_string)
		self.active_field:render(screen)
	end
	self:listen_to(self.keyboard, "update", update_string_callback)

	local exit_keyboard_callback = function()
		self.hasActiveKeyboard = false
		self.keyboard:set_active(false)
		surface:destroy(self.keyboard)
		--self.active_field:render(screen)
		self:render(screen)
		gfx.update()
	end
	self:listen_to(self.keyboard, "exit", exit_keyboard_callback)

	self.content_list = {input_field,input_field2, input_field3, binary_button}
	self.content_pointer = 1

	self.callback = utils.partial(self.load_view, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		self.callback
		--utils.partial(self.load_view, self)
	)
end

function CreateProfileView:render(surface)
	-- -- Resets the surface and draws the background

	surface:clear(self.background_color)

	if self.hasActiveKeyboard==true then
		self.keyboard:render(screen)
	end


	input_field:render(surface)
	input_field2:render(surface)
	input_field3:render(surface)
	binary_button:render(surface)
	-- --surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))
	--
	-- local log_in_button = sys.new_freetype({r=23, g=155, b=23}, 30, {x=700+50,y=35}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	-- surface:fill({r=23, g=0, b=23}, {width=500, height=100, x=700, y=45})
	-- log_in_button:draw_over_surface(surface, "Ok")
	--
	-- local input = sys.new_freetype({r=23, g=155, b=23}, 30, {x=700+50,y=135}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	-- input:draw_over_surface(surface, "namn: ")
	--
	-- keyboard = KeyboardComponent()
	-- keyboard:render(surface)
	-- --logger:trace("active:" .. keyboard:is_active())
	-- if keyboard:is_active() then
	-- 	logger:trace("keyboard ACTIVE")
	-- else
	-- 	logger:trace("keyboard is not active")
	-- end

	--keyboard:set_active(false)


end

function CreateProfileView:load_view(button)

	-- TODO set mappings to RC
	if self.hasActiveKeyboard == true then
		if self.render_ticket == true then
			self.render_ticket = false
			--self.keyboard:render(screen)
		end
			self.keyboard:button_press(button)
	else
		if button == "down" then
			self.content_list[self.content_pointer]:set_highlighted(false)
			if self.content_pointer + 1 > #self.content_list then
				self.content_pointer = 1
			else
				self.content_pointer = self.content_pointer + 1
			end
			self.content_list[self.content_pointer]:set_highlighted(true)
		elseif button == "ok" then
			if self.content_pointer == 1 or self.content_pointer == 2 or self.content_pointer == 3 then
				self.render_ticket = true
				self.active_field = self.content_list[self.content_pointer]
				self.keyboard:new_input(self.active_field.text)
				self.hasActiveKeyboard = true
			elseif self.content_pointer == 4 then
				self.content_list[self.content_pointer]:swap_value()
			end
		end
		self:render(screen)
		gfx.update()
	end
end

return CreateProfileView
