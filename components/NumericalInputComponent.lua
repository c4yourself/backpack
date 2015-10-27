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
	if button == "backspace" then
		if #self.input > 0 then
			self.set_text(self.input:sub(1,-2))
		end
		self.trigger("change")
	elseif button == "ok" then
		self.trigger("submit")
	else
		if button ~= nil then
			self.set_text(self.input .. button)
			self.trigger("change")
		end
	end
	self.test_trigger_flag = true
end

--- Renders the NumericalInputField
function NumericalInputComponent:render()
	-- TODO
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
			"button_press",
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
