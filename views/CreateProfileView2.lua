local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local utils = require("lib.utils")
local SubSurface = require("lib.view.SubSurface")
local Button = require("components.Button")
local InputField	=	require("components.InputField")
local BinaryButton	=	require("components.BinaryButton")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local logger = require("lib.logger")
local City = require("lib.city")
local Profile = require("lib.profile.Profile")
local ProfileManager = require("lib.profile.ProfileManager")
local KeyboardComponent	=	require("components.KeyboardComponent")
local CreateProfileView2 = class("CreateProfileView2", View)

--- Constructor
-- @param remote_control, email, password
function CreateProfileView2:__init(remote_control, email, password)
	View.__init(self)
	self.email = email
	self.password = password

	self.profile_manager = ProfileManager()

	self.button_text = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))

	self.input_field = InputField("Name:", {x = 700, y = 80}, true)
	self.input_field2 = InputField("Date of birth: (YYYY-MM-DD)", {x = 700, y = 230}, false)
	binary_button = BinaryButton("Sex:", "female", "male", {x = 700, y = 380}, false)
	self.active_field = self.input_field

	self.background_color = {r=30, g=35, b=35}
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255)

	self.button_cancel = Button(button_color, color_selected, color_disabled, true, false, "views.ProfileSelection")
	self.button_login = Button(button_color, color_selected, color_disabled, true, false, "views.ProfileSelection")
	self.button_cancel_surface = SubSurface(screen, {width=220, height=75, x=700, y=530})
	self.button_login_surface = SubSurface(screen, {width=220, height=75, x=980, y=530})

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
		--self.active_field:render(screen)
		self:render(screen)
		gfx.update()
	end
	self:listen_to(self.keyboard, "exit", exit_keyboard_callback)

	self.content_list = {self.input_field,self.input_field2, binary_button, self.button_cancel, self.button_login}
	self.content_pointer = 1

	self.callback = utils.partial(self.load_view, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		self.callback
		--utils.partial(self.load_view, self)
	)
end

--- Draws the view on given surface.
-- @param surface
function CreateProfileView2:render(surface)
	surface:clear(self.background_color)

	if self.hasActiveKeyboard==true then
		self.keyboard:render(screen)
	end

	self.input_field:render(surface)
	self.input_field2:render(surface)
	binary_button:render(surface)
	self.button_cancel:render(self.button_cancel_surface)
	self.button_login:render(self.button_login_surface)
	self.button_text:draw(surface, {x=700+50, y=530+15}, "Cancel")
	self.button_text:draw(surface, {x=980+50, y=530+15}, "Create")
end

--- Safeguards for incorrect input goes here.
-- @param
function CreateProfileView2:control_input()
	local ok_input = true
	--local profile_man = ProfileManager()
	if self.input_field.text == "" then --Control for non-empty string
		ok_input = false
	-- elseif self.input_field2.text == "" then -- Date of birth input control
	-- 	ok_input = false
	end
	return ok_input
end

--- A Cancel button call to return to profile selection.
-- @param
function CreateProfileView2:return_to_base_view()
	local ProfileSelection=require("views.ProfileSelection")
	local profile_selection = ProfileSelection(event.remote_control)
	view.view_manager:set_view(profile_selection)
end

--- Runs when a key on the remote control has been pressed.
-- @param button
function CreateProfileView2:load_view(button)
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
			if self.content_pointer == 1 or self.content_pointer == 2 then
				self.render_ticket = true
				self.active_field = self.content_list[self.content_pointer]
				self.keyboard:new_input(self.active_field.text)
				self.hasActiveKeyboard = true
				self:render(screen)
				gfx.update()
			elseif self.content_pointer == 3 then
				self.content_list[self.content_pointer]:swap_value()
				self:render(screen)
				gfx.update()
			elseif self.content_pointer == 4 then
				self:return_to_base_view()
			elseif self.content_pointer == 5 then
				if self:control_input() then
					self.profile = Profile(self.input_field.text, self.email, self.input_field2.text, binary_button:get_value(), City.cities["london"])
					self.profile:set_balance(500)
					self.profile:set_experience(0)
					self.profile:set_password(self.password)
					self.profile:set_id(0)
					self.profile_manager:create_new_profile(self.profile)
					self:return_to_base_view()
				else
					-- Error message pop-up
				end
			end
		end
	end
end

return CreateProfileView2
