--- Base class for NumericalInputComponent
--
-- @classmod NumericalInputComponent

local class = require("lib.classy")
local View = require("lib.view.View")
local NumericalInputComponent = class("NumericalInputComponent", View)

--- Constructor for NumericalInputComponent
-- @param event_listener Remote control to listen to
function NumericalInputComponent:__init(remote_control)
	self.input = ""
	self.focused = false
	if event_listener ~= nil then
		self:listen_to(remote_control, "button_press", partial(self.press, self))
	else
		self:listen_to(event.remote_control, "button_press", partial(self.press, self))
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
		if button ~= nil
			self.set_text(self.input .. button)
			self.trigger("change")
		end
	end
end

--- Renders the NumericalInputField
function NumericalInputComponent:render()
	-- TODO
	font:draw_over_surface(screen, self.input)
	gfx.update()
	self.is_dirty = false
end

--- defocuses the NumericalInputComponent
function NumericalInputComponent:blur()
	if self:is_focused() then
		-- stop_listening to this component
		self:stop_listening() -- make sure this works
		self.focused = false
	end
end

--- Focuses the NumericalInputComponent
function NumericalInputComponent:focus()
	if not self:is_focused() then
		self.listen_to(
			remote_control,
			"button_press",
			partial(self.press, self)
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
	if tonumber(button) ~= nil then
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
