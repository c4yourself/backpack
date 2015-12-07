local class = require("lib.classy")
local ColorButton = require("components.ColorButton")
local Rectangle = require("lib.draw.Rectangle")

local SurfaceButton = class("SurfaceButton", ColorButton)

function SurfaceButton:__init(
		surface, color, color_selected, color_disabled, enabled, selected)
	ColorButton.__init(
		self, color, color_selected, color_disabled, enabled, selected)

	self.surface = surface
end

function SurfaceButton:destroy()
	ColorButton.destroy(self)
	self.surface:destroy()
end

function SurfaceButton:render(surface)
	ColorButton._render(self, surface)

	local button_rectangle = Rectangle.from_surface(surface)
	local surface_rectangle = Rectangle(
		0,
		0,
		math.min(button_rectangle.width, self.surface:get_width()),
		math.min(button_rectangle.height, self.surface:get_height()))

	surface:copyfrom(
		self.surface,
		surface_rectangle:to_table(),
		surface_rectangle:translate(
			button_rectangle.width / 2 - surface_rectangle.width / 2,
			button_rectangle.height / 2 - surface_rectangle.height / 2):to_table(),
		true)
	self:dirty(false)
end

return SurfaceButton
