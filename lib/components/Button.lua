--- Button class.
-- @classmod Button

local class = require("lib.classy")
local View = require("lib.view.View")
local Button = class("Button", View)

--- Constructor for Button
--@param color The color of button which is neither disabled nor selected
--@param color_selected The color for a selected button
--@param color_disabled The color for a disabled button
--@param enabled The button is enabled or not when instantiating
--@param selected The button is selected or not when instantiating
--@param transfer_path The path for the view after the button is clicked
function Button:__init(color, color_selected, color_disabled, enabled, selected, transfer_path)
	View.__init(self)
	self.color = color
	self.color_selected = color_selected or color
	self.color_disabled = color_disabled or color
	self._enabled = enabled or true
	self._selected = selected or false
	self.text_available = false
	if transfer_path ~= nil then
		self.transfer_path = transfer_path
	end
end

function Button:set_view_path(transfer_path)
	self.transfer_path = transfer_path

end

function Button:set_textdata(text, font_color, text_position, font_size,font_path)
	self.text_available = true
	self.text = text
	self.font_size = font_size
	self.font_color = font_color
	self.font_path = font_path
	self.text_position = text_position

end

function Button:enable(status)

	if status == nil then
		status = true
	end

	local old_status = self._enabled
	self._enabled = status

	self:dirty(false)
	self:dirty(true)
end

function Button:is_enabled()
	return self._enabled
end

function Button:select(status)

	if status == nil then
		status = true
	end

	local old_status = self._selected
	self._selected = status
	self:dirty(true)
end

function Button:is_selected()
	return self._selected
end

function Button:render(surface)
	self:dirty(false)

	if not self:is_enabled() then
		surface:fill(self.color_disabled:to_table())
	elseif self:is_selected() then
		surface:fill(self.color_selected:to_table())
	else
		surface:fill(self.color:to_table())
	end

end


return Button
