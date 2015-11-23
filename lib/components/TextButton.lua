--- TextButton class.
-- @classmod TextButton

local class = require("lib.classy")
local View = require("lib.view.View")
local TextButton = class("TextButton", View)

--- Constructor for TextButton
--@param color The color of TextButton which is neither disabled nor selected
--@param color_selected The color for a selected TextButton
--@param color_disabled The color for a disabled TextButton
--@param enaled The TextButton is enabled or not when instantiating
--@param selected The TextButton is selected or not when instantiating
--@param transfer_path The path for the view after the TextButton is clicked
function TextButton:__init(font_path, fint_size, enabled, selected, transfer_path)
	View.__init(self)
	self.color = {r=250, g=105, b=0}
	self.color_selected = {r=250, g=169, b=0}
	self.color_disabled = {r=123, g=123, b=123}
	self._enabled = enabled or true
	self._selected = selected or false
	self.text_available = false
	self.font_size = font_size
	self.font_color = {r=255, g=255, b=255}
	self.font_path = font_path
	if transfer_path ~= nil then
		self.transfer_path = transfer_path
	end
end

function TextButton:set_view_path(transfer_path)
	self.transfer_path = transfer_path
end

function TextButton:enable(status)

	if status == nil then
		status = true
	end

	local old_status = self._enabled
	self._enabled = status

	self:dirty(false)
	self:dirty(true)
end

function TextButton:is_enabled()
	return self._enabled
end

function TextButton:set_textdata(text_content)
	--self.text_available = true
	self.text = text_content
end

function TextButton:select(status)

	if status == nil then
		status = true
	end

	local old_status = self._selected
	self._selected = status
	self:dirty(true)
end

function TextButton:is_selected()
	return self._selected
end

function TextButton:render(surface)
	self:dirty(false)

	if not self:is_enabled() then
		surface:fill(self.color_disabled)
	elseif self:is_selected() then
		surface:fill(self.color_selected)
	else
		surface:fill(self.color)
	end

end


return TextButton
