--- Base class for LoginView
-- The LoginView is the View where you can login to an account
-- @classmod LoginView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local utils = require("lib.utils")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local SubSurface = require("lib.view.SubSurface")
local Button = require("components.Button")
local InputField	=	require("components.InputField")
local BinaryButton	=	require("components.BinaryButton")
local color = require("lib.draw.Color")
local logger = require("lib.logger")
local KeyboardComponent	=	require("components.KeyboardComponent")
local ProfileManager = require("lib.profile.ProfileManager")

local LoginView = class("LoginView", View)

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function LoginView:__init(remote_control, profile_selection)
	View.__init(self)
	self.profile_selection = profile_selection
	self.background_path = ""
	self.email_input_field = InputField("Email:", {x = 700, y = 80}, true)
	self.password_input_field = InputField("Password:", {x = 700, y = 230}, false)
  self.password_input_field:set_private(true)


	--Button data
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255)
	local button_size = {width = 100, height = 100}
	self.button_cancel = Button(button_color, color_selected, color_disabled, true, false, "views.ProfileSelection")
	self.button_cancel_text = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.button_cancel_surface = SubSurface(screen, {width=500, height=100, x=700, y=530})
	self.button_login = Button(button_color, color_selected, color_disabled, true, false, "views.ProfileSelection")
	self.button_login_text = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.button_login_surface = SubSurface(screen, {width=500, height=100, x=700, y=380})
	-- buttons done

	self.active_field = self.email_input_field
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
		--surface:destroy(self.keyboard)
		self:render(screen)
		gfx.update()
	end
	self:listen_to(self.keyboard, "exit", exit_keyboard_callback)

	self.content_list = {self.email_input_field,self.password_input_field, self.button_login, self.button_cancel}
	self.content_pointer = 1

	self.callback = utils.partial(self.load_view, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		self.callback
		--utils.partial(self.load_view, self)
	)

	self.profile_manager = ProfileManager()
end

function LoginView:render(surface)
	-- -- Resets the surface and draws the background

	surface:clear(self.background_color)

	if self.hasActiveKeyboard==true then
		self.keyboard:render(screen)
	end


	self.email_input_field:render(surface)
  self.password_input_field:render(surface)
	self.button_cancel:render(self.button_cancel_surface)
	self.button_login:render(self.button_login_surface)
	self.button_cancel_text:draw(surface, {x=700+190, y=530+20}, "Cancel")
	self.button_login_text:draw(surface, {x=700+200, y=380+20}, "Log in")


end

function LoginView:load_view(button)

	-- TODO set mappings to RC
	if self.hasActiveKeyboard == true then
		if self.render_ticket == true then
			self.render_ticket = false
			--self.keyboard:render(screen)
		end
			self.keyboard:button_press(button)
	else
		if button == "down" then
			if self.content_pointer == 1 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 2
				self.content_list[self.content_pointer]:select(true)
			elseif self.content_pointer == 2 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 3
				self.content_list[self.content_pointer]:select(true)
			elseif self.content_pointer == 3 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 4
				self.content_list[self.content_pointer]:select(true)

			elseif self.content_pointer == 4 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 1
				self.content_list[self.content_pointer]:select(true)
			end
			self:render(screen)
		elseif button == "up" then
			if self.content_pointer == 1 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 4
				self.content_list[self.content_pointer]:select(true)
			elseif self.content_pointer == 2 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 1
				self.content_list[self.content_pointer]:select(true)
			elseif self.content_pointer == 3 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 2
				self.content_list[self.content_pointer]:select(true)
			elseif self.content_pointer == 4 then
				self.content_list[self.content_pointer]:select(false)
				self.content_pointer = 3
				self.content_list[self.content_pointer]:select(true)
			end
			self:render(screen)
		elseif button == "ok" then
			if self.content_pointer == 1 or self.content_pointer == 2 then
				self.render_ticket = true
				self.active_field = self.content_list[self.content_pointer]
				self.keyboard:new_input(self.active_field.text)
				self.hasActiveKeyboard = true
				self:render(screen)
			elseif self.content_pointer == 3 then
				--logger:trace("detta står i email: " .. self.email_input_field:get_text())
				--logger:trace("detta står i password: " .. self.password_input_field:get_text())
				--loginProfile = ProfileManager:login(self.email_input_field:get_text(),self.password_input_field:get_text())
				worked, result = self.profile_manager:login(self.email_input_field:get_text(),self.password_input_field:get_text())

				ProfileSelection = require("views.ProfileSelection")
				local profile_selection = ProfileSelection(event.remote_control)

				view.view_manager:set_view(profile_selection)
				--profile_selection:render(screen)
				--gfx.update()


			elseif self.content_pointer == 4 then
				--logger:trace("INNNNNE" .. self.email_input_field:get_text())

				ProfileSelection = require("views.ProfileSelection")
				local profile_selection = ProfileSelection(event.remote_control)

				view.view_manager:set_view(profile_selection)
				--profile_selection:render(screen)
				--gfx.update()
			end
		end
		gfx.update()
	end
end

return LoginView
