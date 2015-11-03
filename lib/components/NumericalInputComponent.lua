--- Base class for NumericalInputComponent
--
-- @classmod NumericalInputComponent

local class = require("lib.classy")
local View = require("lib.view.View")
local NumericalInputComponent = class("NumericalInputComponent", View)
local event = require("lib.event")
local utils = require("lib.utils")

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
end

-- NumericalInputComponent responds to a button press event
function NumericalInputComponent:press(button)
	print("NumInput noticed a button press")
	if button == "backspace" then
		if #self.input > 0 then
			if #self.input == 1 then
				self:set_text("")
			end
			self:set_text(self.input:sub(1,-2))
		end
		self:trigger("change")
	elseif button == "ok" then
		self:trigger("submit")
	else
		if button ~= nil and tonumber(button) ~= nil then
			print("NumInpComp triggers change")
			print("button")
			print(button)
			self:set_text(self.input .. button)
			self:trigger("change")
		end
	end
	self.test_trigger_flag = true
end

--- Renders the NumericalInputField
function NumericalInputComponent:render(surface)
	-- Draw  Numerical
	local font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 25, y = 50},
		utils.absolute_path("data/fonts/DroidSans.ttf"))
	color1 = {
			r = 255, g = 0, b = 0, a = 255
		}
	rectangle = {
			x = 0, y = 0, width = 299, height = 149, w = 299, h =149
		}
	surface:clear(color1, rectangle)
	font:draw_over_surface(surface, self.input)
	gfx.update()
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
	print("numericalinput focus called")
	if not self:is_focused() then
		self:listen_to(
			self.event_listener,
			"button_release",
			utils.partial(self.press, self)
		)
		self:listen_to(
			self.event_listener,
			"button_press",
			utils.partial(self.press, self)
		)
		self.focused = true
	end
	if self.focused then
		print("numerical input focused: true")
	end
end

--- Checks if the component is focused or not
function NumericalInputComponent:is_focused()
	return self.focused
end

--- Sets the input string, can be fed a nil value to remove the current input
-- @param text String to be displayed in the input field
-- @throws Error if text can't be parsed as a number
function NumericalInputComponent:set_text(text)
	print("set text called")
	print(text)
	if tonumber(text) ~= nil then
		self.input = text
		self.dirty_flag = true
 	elseif text == nil or text == "" then
		self.input = ""
		self.dirty_flag = true
	else
		error("Only numerical inputs are accepted")
	end
end

--- Returns the current input string
function NumericalInputComponent:get_text()
	return self.input
end

return NumericalInputComponent
