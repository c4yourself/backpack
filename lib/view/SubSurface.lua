local class = require("lib.classy")
local Color = require("lib.color")
local SubSurface = class("SubSurface")

--- Constructor for Subsurface.
function SubSurface:__init(surface, area)

	self.surface = surface

	self.rectangle = area
	self.x = area.x
	self.y = area.y
	self.width = area.width
	self.height = area.height
	self.xend = self.x + self.width
	self.yend = self.y + self.height
end

--- Fills desired area of the surface with a solid color.
function SubSurface:clear(color, rectangle)

	local c = {
		r = color.r,
		g = color.g,
		b = color.b,
		a = color.a
	}

	local rect = {
		x = self.x,
		y = self.y,
		width = self.width,
		height = self.height
	}

	if rectangle ~= nil then
		rect.x = rectangle.x + self.x
		rect.y = rectangle.y + self.y
		rect.width = rectangle.width
		rect.height = rectangle.height
	end

	local w = rect.x + rect.width - 1
	local h = rect.y + rect.height - 1
	for i = rect.x, w do
		for j = rect.y, h do
			--print(c.r)

			self.surface:set_pixel(i, j, c)
		end
	end

end

--- Blends current color with a desireable color in a speciefied rectangle
function SubSurface:fill(color, rectangle)

	local rect = {
		x = self.x,
		y = self.y,
		width = self.width,
		height = self.height
	}

	if rectangle ~= nil then
		rect.x = rectangle.x + self.x
		rect.y = rectangle.y + self.y
		rect.width = rectangle.width
		rect.height = rectangle.height
	end
	self.surface:fill(color, rect)
end

--- Copy pixels from another surface into this
function SubSurface:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)

	local source_rectangle = {}


	--if src_rectangle is nil, defaul to entire source surface
	if src_rectangle == nil then
		source_rectangle.x = 0
		source_rectangle.y = 0
		source_rectangle.w = src_surface.image_data:getWidth()
		source_rectangle.h = src_surface.image_data:getHeight()
	else
		source_rectangle.x = src_rectangle.x or 0
		source_rectangle.y = src_rectangle.y or 0
		source_rectangle.w = src_rectangle.w or src_surface.image_data:getWidth()
		source_rectangle.h = src_rectangle.h or src_surface.image_data:getHeight()
	end
		print(src_rectangle.h)
	local destination_rectangle = {}

	--if src_rectangle is nil, defaul to enture source surface
	if dest_rectangle == nil then
		destination_rectangle.x = 0
		destination_rectangle.y = 0
		destination_rectangle.w = src_surface.image_data:getWidth()
		destination_rectangle.h = src_surface.image_data:getHeight()
	else
		destination_rectangle.x = dest_rectangle.x or 0
		destination_rectangle.y = dest_rectangle.y or 0
		destination_rectangle.w = dest_rectangle.w or src_surface.image_data:getWidth()
		destination_rectangle.h = dest_rectangle.h or src_surface.image_data:getHeight()
	end


	local scale_x = destination_rectangle.w / source_rectangle.w
	local scale_y = destination_rectangle.h / source_rectangle.h

	local dest_w = destination_rectangle.x + destination_rectangle.w
	local dest_h = destination_rectangle.y + destination_rectangle.h

	local src_w = source_rectangle.x + source_rectangle.w
	local src_h = source_rectangle.y + source_rectangle.h


	if scale_x >= 1 then
 		if scale_y >= 1 then
			for i = source_rectangle.x, src_w do
				for j = source_rectangle.y, src_h do
					r,g,b,a = src_surface.image_data:getPixel(i, j)

					local c = {
						r = r,
						g = g,
						b = b,
						a = a
					}
					print(i .. ":" .. j .. "--" .. c.r .."-" .. c.g .. "-" ..c.b .. "-" .. c.a)
					self.surface.image_data:setPixel(i, j, c.r, c.g, c.b, c.a)
				end
			end
		end
	end
end

--- Get this Subsurface's width
function SubSurface:get_width()
	return self.width
end

--- Get this Subsurface's height
function SubSurface:get_height()
	return self.height
end

--- Get color of the pixel at location x and y
function SubSurface:get_pixel(x,y)
	x = x + self.x
	y = y + self.y
	r, g, b, a = self.surface:get_pixel( x, y )
	return r, g, b, a
end

--- Set color of the pixel at location x and y
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

return SubSurface
