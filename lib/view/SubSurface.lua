local class = require("lib.classy")
local logger = require("lib.logger")
local Rectangle = require("lib.draw.Rectangle")

local SubSurface = class("SubSurface")

--- Constructor for SubSurface class
-- @param surface the surface this subsurface shall be written on
-- @param area the size and starting poin(x,y) of this subsurface
function SubSurface:__init(surface, area)
	self.surface = surface

	self.x = math.min(area.x)
	self.y = math.min(area.y)
	self.width = math.min(area.width)
	self.height = math.min(area.height)

	self.xend = self.x + self.width - 1 -- End of Subsurface x
	self.yend = self.y + self.height - 1 -- End of Subsurface y
end

--- Fills desired area of the surface with a solid color.
-- @param color the color to paint subsurface with
-- @param rectangle area to paint, defaults to entire subsurface
function SubSurface:clear(color, rectangle)
	local rect = self:_get_rectangle(rectangle)
	self.surface:clear(color, rect)
end

--- Blends current color with a desireable color in a speciefied rectangle
-- @param color the blending color
-- @param rectangle the area to blend, defaults to entire subsurface
function SubSurface:fill(color, rectangle)
	local rect = self:_get_rectangle(rectangle)
	self.surface:fill(color, rect)
end

--- Copy pixels from another surface into this SubSurface
-- @param src_surface the surface to copy from
-- @param src_rectangle the area on src_surface to copy from
-- @param dest_rectangle the are on subsurface to copy to
-- @param blend_option
function SubSurface:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)
	local src_rect = self:_get_surface_rectangle(src_surface, src_rectangle)
	local dest_rectangle = self:_get_rectangle(dest_rectangle, src_rect)

	self.surface:copyfrom(src_surface, src_rect, dest_rectangle, blend_option)
end

--- Get this Subsurface's width
-- @return int width for this pixel
function SubSurface:get_width()
	return self.width
end

--- Get this Subsurface's height
-- @return int height for this subsurface
function SubSurface:get_height()
	return self.height
end

--- Get color of the pixel at location x and y
-- @param x the x cordinate to return color for
-- @param y the y cordinate to return color for
-- @return int color values for this pixel
function SubSurface:get_pixel(x, y)
	x = x + self.x
	y = y + self.y
	r, g, b, a = self.surface:get_pixel( x, y )
	return r, g, b, a
end

--- Set color of the pixel at location x and y
-- @param x the x cordinate to set color for
-- @param y the y cordinate to set color for
-- @param color the color to set at this pixel
function SubSurface:set_pixel(x, y, color)
	x = x + self.x
	y = y + self.y
	self.surface:set_pixel(x, y, color)
end

--- Does nothing, but needed for feature parity with the regular surface class.
function SubSurface:premultiply()
	--TODO
end

--- Destroys link between Subsurface and it's original surface
function SubSurface:destroy()
	self.surface = nil
end

--- Modifies the alpha value of every pixel within this surface
-- @param alpha the alphavalue to modify pixelcolor with
function SubSurface:set_alpha(alpha)
	for i = self.x, self.xend do
		for j = self.y, self.yend do
			r, g, b, a = self.surface:get_pixel(i, j)
			color = {
				r = r,
				g = g,
				b = b,
				a = alpha
			}
			self.surface:set_pixel(i, j, color)
		end
	end
end

--- Creates an rectangle(table) which is easier to work with
-- @param rectangle an rectangle to convert
-- @return Table with rectangle x, y, width and height values
function SubSurface:_get_rectangle(rectangle, defaults)
	if defaults == nil then
		defaults = {
			width = self:get_width(),
			height = self:get_height()
		}
	end

	local rect = Rectangle.from_table(rectangle, {
		width = defaults.width or defaults.w,
		height = defaults.height or defaults.h
	}):translate(self.x, self.y)

	local surface_rect = Rectangle(
		self.x, self.y, self.width, self.height)

	-- Throw error when trying to draw outside of screen
	if not surface_rect:contains(rect) then
		logger.error(string.format(
			"Rectange start is %dx%d, end is %dx%d. Max is ",
			rect:get_start(),
			rect:get_end(),
			surface_rect:get_end()))
		error("Rectangle is out of bounds")
	end

	return rect:to_table()
end

--- Reimplementation of @{emulator.surface:_get_rectangle} which is only
-- available
function SubSurface:_get_surface_rectangle(surface, rectangle, defaults)
	if defaults == nil then
		defaults = {
			width = surface:get_width(),
			height = surface:get_height()
		}
	end

	local rect = Rectangle.from_table(rectangle, {
		width = defaults.width or defaults.w,
		height = defaults.height or defaults.h
	})

	local surface_rect = Rectangle.from_surface(surface)

	-- Throw error when trying to draw outside of screen
	if not surface_rect:contains(rect) then
		logger.error(string.format(
			"Rectange start is %dx%d, end is %dx%d. Max is %dx%d",
			rect:get_start(),
			rect:get_end(),
			surface_rect:get_end()))
		error("Rectangle is out of bounds")
	end

	return rect:to_table()
end


return SubSurface
