--- Base class for CreateProfileView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CreateProfileView

local class = require("lib.classy")
local view = require("lib.view")
local View = require("lib.view.View")
local event = require("lib.event")
local utils = require("lib.utils")
local SubSurface = require("lib.view.SubSurface")
local button= require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local InputField	=	require("components.InputField")
local BinaryButton	=	require("components.BinaryButton")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local logger = require("lib.logger")
local Profile = require("lib.profile.Profile")
local KeyboardComponent	=	require("components.KeyboardComponent")
local CreateProfileView2 = require("views.CreateProfileView2")
local CreateProfileView = class("CreateProfileView", View)

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CreateProfileView:__init(remote_control)
	View.__init(self)
	self.remote_control = remote_control

	self.button_text = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.input_field = InputField("Mail:", {x = 700, y = 80}, true)
	self.input_field2 = InputField("Password:", {x = 700, y = 230}, false)
	self.input_field2:set_private(true)
	self.input_field3 = InputField("Confirm Password:", {x = 700, y = 380}, false)
	self.input_field3:set_private(true)

	self.background_color = {r=30, g=35, b=35}
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255)

	self.button_cancel = button(button_color, color_selected, color_disabled, true, false, "views.ProfileSelection")
	self.button_login = button(button_color, color_selected, color_disabled, true, false, "views.ProfileSelection")
	self.button_cancel_surface = SubSurface(screen, {width=220, height=75, x=700, y=530})
	self.button_login_surface = SubSurface(screen, {width=220, height=75, x=980, y=530})

	self.active_field = self.input_field

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
		self:render(screen)
		gfx.update()
	end
	self:listen_to(self.keyboard, "exit", exit_keyboard_callback)

	self.content_list = {self.input_field, self.input_field2, self.input_field3, self.button_cancel, self.button_login}
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


	self.input_field:render(surface)
	self.input_field2:render(surface)
	self.input_field3:render(surface)
	self.button_cancel:render(self.button_cancel_surface)
	self.button_login:render(self.button_login_surface)
	self.button_text:draw(surface, {x=700+50, y=530+15}, "Cancel")
	self.button_text:draw(surface, {x=980+70, y=530+15}, "Next")
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
		if button == "down" or button == "right" then
			self.content_list[self.content_pointer]:select(false)
			if self.content_pointer + 1 > #self.content_list then
				self.content_pointer = 1
			else
				self.content_pointer = self.content_pointer + 1
			end
			self.content_list[self.content_pointer]:select(true)
			self:render(screen)
			gfx.update()
		elseif button == "up" or button == "left" then
			self.content_list[self.content_pointer]:select(false)
			if self.content_pointer - 1 < 1 then
				self.content_pointer = #self.content_list
			else
				self.content_pointer = self.content_pointer - 1
			end
			self.content_list[self.content_pointer]:select(true)
			self:render(screen)
			gfx.update()
		elseif button == "ok" then
			if self.content_pointer == 1 or self.content_pointer == 2 or self.content_pointer == 3 then
				self.render_ticket = true
				self.active_field = self.content_list[self.content_pointer]
				self.keyboard:new_input(self.active_field.text)
				self.hasActiveKeyboard = true
				self:render(screen)
				gfx.update()
			elseif self.content_pointer == 4 then
				local ProfileSelection=require("views.ProfileSelection")
				local profile_selection = ProfileSelection(event.remote_control)
				view.view_manager:set_view(profile_selection)
			elseif self.content_pointer == 5 then
				--if self.input_field2.text == self.input_field3.text then
				self.create_profile_2 = CreateProfileView2(self.remote_control, self.input_field.text, self.input_field2.text)
				view.view_manager:set_view(self.create_profile_2)
			end
		end
	end
end

return CreateProfileView
