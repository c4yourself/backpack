--- NumericalInputComponent class. Used for numerical input in the numerical
-- quiz.
-- @classmod NumericalInputComponent

local class = require("lib.classy")
local View = require("lib.view.View")
local NumericalInputComponent = class("NumericalInputComponent", View)
local event = require("lib.event")
local utils = require("lib.utils")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")

--- Constructor for NumericalInputComponent
-- @param remote_control Remote control to listen to. Defaults to the global
--			remote_control instance
function NumericalInputComponent:__init(remote_control)
	View.__init(self)
	self.input = ""
	self.focused = false
	self._selected = false
	self.test_trigger_flag = false -- variable used for testing
	if remote_control ~= nil then
		self.event_listener = remote_control
	else
		self.event_listener = event.remote_control
	end
	-- Graphics
	self.color = {r = 255, g = 0, b = 0, a = 255}
	self.color_selected = {r = 0, b = 255, g = 0, a = 255}
	self.color_disabled = {r = 255, b = 255, g = 255, a = 255}
end

--- Selects or de-selects the input component
--@param status Boolean representing a new status
function NumericalInputComponent:select(status)
	if status == nil then
		status = true
	end

	local old_status = self._selected
	self._selected = status
	self:focus()
	self:dirty(true)
end

--- Checks if the input field is currently selected by the user
--@return Boolean signifying whether the input field is selected or not.
function NumericalInputComponent:is_selected()
	return self._selected
end

-- NumericalInputComponent responds to a button press even
--@param button Button that was pressed by the user
function NumericalInputComponent:press(button)
	if button == "backspace" then
		if #self.input > 0 then
			if #self.input == 1 then
				self:set_text("")
			end
			self:set_text(self.input:sub(1,-2))
		end
		self:trigger("change")
	elseif button == "ok" then
		if #self.input > 0 then
			self:trigger("submit")
		end
	else
		if button ~= nil and tonumber(button) ~= nil
		and #self.input < 3 then
			self:set_text(self.input .. button)
			self:trigger("change")
		end
	end
	self.test_trigger_flag = true
end

--- Renders the NumericalInputField and all its child components on the
-- specified surface
--@param surface @{Surface} or @{SubSurface} to render on
function NumericalInputComponent:render(surface)
	if self._selected == true then
		self:focus()
		surface:clear(self.color_selected)
	else
		self:blur()
		surface:clear(self.color)
	end
	self.width = surface:get_width()
	self.height = surface:get_height()
	local question_font = Font("data/fonts/DroidSans.ttf", 32, Color(255,255,255,255))
	question_font:draw(surface, {x = 0, y = 0,
			height = self.height, width = self.width}, self.input,
			"center", "middle")
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
--@return Boolean signifying whether the field us focused or not
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
--@return String with the input currently in the input field
function NumericalInputComponent:get_text()
	return self.input
end

return NumericalInputComponent
