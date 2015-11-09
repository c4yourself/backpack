local class = require("lib.classy")
local copysurface = require("emulator.surface")
local SubSurface = class("SubSurface")




--- Constructor for SubSurface class
-- @param surface the surface this subsurface shall be written on
-- @param area the size and starting poin(x,y) of this subsurface
function SubSurface:__init(surface, area)

	self.surface = surface
	self.rectangle = area
	self.x = area.x
	self.y = area.y
	self.width = area.width
	self.height = area.height
	self.xend = self.x + self.width -- End of Subsurface x
	self.yend = self.y + self.height -- End of Subsurface y
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
function SubSurface:copy_from(src_surface, src_rectangle, dest_rectangle, blend_option)
	local surfaceCopy = copysurface(self.width, self.height)
	surfaceCopy:copyfrom(src_surface, src_rectangle, blend_option)

	for i = 0, (dest_rectangle.width - 1) do
		for j = 0, (dest_rectangle.height - 1) do

			r, g, b, a = surfaceCopy:get_pixel(i, j)
			color = {
				r = r,
				g = g,
				b = b,
				a = a
			}

			local setx = i + dest_rectangle.x + self.x
			local sety = j + dest_rectangle.y + self.y
			self.surface:set_pixel(setx, sety, color)
		end
	end
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
function SubSurface:get_pixel(x,y)
	x = x + self.x
	y = y + self.y
	r, g, b, a = self.surface:get_pixel( x, y )
	return r, g, b, a
end

--- Set color of the pixel at location x and y
-- @param x the x cordinate to set color for
-- @param y the y cordinate to set color for
-- @param color the color to set at this pixel
function SubSurface:set_pixel(x,y,color)
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
function SubSurface:_get_rectangle(rectangle)
	local rect = {
		x = self.x,
		y = self.y,
		width = self.width,
		height = self.height
	}

	if rectangle == nil then
		return rect
	end

	rect.x = self.x + rectangle.x or rect.x
	rect.y = self.y + rectangle.y or rect.y
	rect.width = (rectangle.width or rectangle.w or rect.width)
	rect.height = (rectangle.height or rectangle.h or rect.height)

	local end_x = self.x + rect.x + rect.width - 1
	local end_y = self.y + rect.y + rect.height - 1

	-- Throw error when trying to draw outside of screen
	if end_x >= self.width or end_y >= self.height then
		logger.error(string.format(
			"Rectange start is %dx%d, end is %dx%d. Max is %dx%d",
			rect.x, rect.y,
			end_x, end_y,
			self.width - 1, self.height - 1))
		error("Rectangle is out of bounds")
	end

	return rect
end


return SubSurface
