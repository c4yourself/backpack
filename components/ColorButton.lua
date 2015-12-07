--- A button with different colors for different states.
-- @classmod ColorButton

local class = require("lib.classy")
local View = require("lib.view.View")

local ColorButton = class("ColorButton", View)

--- Constructor for ColorButton
--@param color The color of button which is neither disabled nor selected
--@param color_selected The color for a selected button
--@param color_disabled The color for a disabled button
--@param enabled The button is enabled or not when instantiating
--@param selected The button is selected or not when instantiating
function ColorButton:__init(
		color, color_selected, color_disabled, enabled, selected)
	View.__init(self)

	self.color = color
	self.color_selected = color_selected or color
	self.color_disabled = color_disabled or color
	self._enabled = enabled or true
	self._selected = selected or false
end

--- Set if the button is enabled or not. If the status was changed the button
-- is marked as dirty.
-- @param[opt] status Enable status. Default value is true
function ColorButton:enable(status)
	if status == nil then
		status = true
	end

	local old_status = self._enabled
	self._enabled = status

	if old_status ~= status then
		self:dirty(true)
	end
end

--- Get button enable status.
-- @return True if button is enabled, false otherwise
function ColorButton:is_enabled()
	return self._enabled
end

--- Set if the button is selected or not. If the status was changed the button
-- is marked as dirty.
-- @param[opt] status Selected status. Default value is true
function ColorButton:select(status)
	if status == nil then
		status = true
	end

	local old_status = self._selected
	self._selected = status

	if old_status ~= status then
		self:dirty(true)
	end
end

--- Get button selection status.
-- @return True if button is selected, false otherwise
function ColorButton:is_selected()
	return self._selected
end

--- Render button.
-- @local
function ColorButton:_render(surface)
	if not self:is_enabled() then
		surface:fill(self.color_disabled:to_table())
	elseif self:is_selected() then
		surface:fill(self.color_selected:to_table())
	else
		surface:fill(self.color:to_table())
	end
end

--- Render button and mark as not dirty.
function ColorButton:render(surface)
	self:_render(surface)
	self:dirty(false)
end

return ColorButton
