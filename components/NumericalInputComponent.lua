--- Base class for NumericalInputComponent
--
-- @classmod NumericalInputComponent

local class = require("lib.classy")
local View = require("lib.view.View")
local NumericalInputComponent = class("NumericalInputComponent", View)
local event = require("lib.event")
local utils = require("lib.utils")
local sys = require("emulator.sys")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")

--- Constructor for NumericalInputComponent
-- @param event_listener Remote control to listen to
function NumericalInputComponent:__init(remote_control)
	View.__init(self)
	self.input = ""
	self.focused = false
	self.test_trigger_flag = false -- variable used for testing
	if remote_control ~= nil then
		self.event_listener = remote_control
	else
		self.event_listener = event.remote_control
	end
	-- Graphics
	self.color1 = {
			r = 255, g = 0, b = 0, a = 255
		}
end

-- NumericalInputComponent responds to a button press event
function NumericalInputComponent:press(button)
	if button == "backspace" then
		if #self.input > 0 then
			if #self.input == 1 then
				self:set_text("")
			end
			self:set_text(self.input:sub(1,-2))
		end
		self:trigger("change")
		print("change triggered")
	elseif button == "ok" then
		self:trigger("submit")
		print("submit triggered")
	else
		if button ~= nil and tonumber(button) ~= nil
		and #self.input < 3 then
			self:set_text(self.input .. button)
			self:trigger("change")
			print("change triggered")
		end
	end
	self.test_trigger_flag = true
end

--- Renders the NumericalInputField
function NumericalInputComponent:render(surface)
	surface:clear(self.color1)
	local surface_width = surface:get_width()
	local surface_height = surface:get_height()
	local question_font = Font("data/fonts/DroidSans.ttf", 32, Color(255,255,255,255))
	question_font:draw(surface, {x = 0, y = 0,
			height = surface_height, width = surface_width}, self.input,
			"center", "middle")
	--font:draw_over_surface(surface, self.input)
	gfx.update()
	self:dirty(false)
end

--- De-focuses the NumericalInputComponent, i.e. stops listening to events
function NumericalInputComponent:blur()
	if self:is_focused() then
		self:stop_listening()
		self.focused = false
	end
end

--- Focuses the NumericalInputComponent, i.e. starts to listening to events
function NumericalInputComponent:focus()
	if not self:is_focused() then
		self:listen_to(
			self.event_listener,
			"button_release",
			utils.partial(self.press, self)
		)
		self.focused = true
	end
end

--- Checks if the component is focused or not
function NumericalInputComponent:is_focused()
	return self.focused
end

--- Sets the input string
-- @param text String to be displayed in the input field
-- @throws Error if text can't be parsed as a number
function NumericalInputComponent:set_text(text)
	if tonumber(text) ~= nil then
		self.input = text
		self:dirty(true)
	elseif text == nil or text == "" then
		self.input = ""
		self:dirty(true)
	else
		error("Only numerical inputs are accepted")
	end
end

--- Returns the current input string
function NumericalInputComponent:get_text()
	return self.input
end

return NumericalInputComponent
