local class = require("lib.classy")
local ColorButton = require("components.ColorButton")
local Rectangle = require("lib.draw.Rectangle")

local TextButton = class("TextButton", ColorButton)

function TextButton:__init(
		text, font, color, color_selected, color_disabled, enabled,
		selected)
	ColorButton.__init(
		self, color, color_selected, color_disabled, enabled, selected)

	self.text = text
	self.font = font
end

function TextButton:render(surface)
	ColorButton._render(self, surface)
	self.font:draw(
		surface, Rectangle.from_surface(surface), self.text, "center", "middle")
	self:dirty(false)
end

return TextButton
