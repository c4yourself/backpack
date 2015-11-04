local class = require("lib.classy")

local Subsurface = class("Subsurface")


function Subsurface:__init(surface, area)
	self.surface = surface
  self.rectangle = area
  self.x = area.x
  self.y = area.y
  self.width = area.width
  self.height = area.height
	self.xend = self.x + self.width
	self.yend = self.y + self.height
end

function Subsurface:clear(color, rectangle)

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
			self.surface.image_data:setPixel(i, j, c.r, c.g, c.b, c.a)
		end
	end

end

function Subsurface:fill(color, rectangle)
	Subsurface:clear(color, rectangle)
end

function Subsurface:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)
 --TODO
end

function Subsurface:get_width()
	return self.width
end

function Subsurface:get_height()
	return self.height
end

function Subsurface:get_pixel(x,y)
	x = x + self.x
	y = y + self.y
	r, g, b, a = self.surface.image_data:getPixel( x, y )
	return r, g, b, a
end

function Subsurface:set_pixel(x,y,color)
	x = x + self.x
	y = y + self.y
	self.surface.image_data:setPixel(x, y, color.r, color.g, color.b, color.a)
end

function Subsurface:premultiply()
	--TODO
end

function Subsurface:destroy()
	self.surface = nil
end

function Subsurface:set_alpha(alpha)
	for i = self.x, self.xend do
		for j = self.y, self.yend do
			r, g, b, a = self.surface.image_data:getPixel(i, j)
			self.surface.image_data:setPixel(i, j, r, g, b, alpha)
		end
	end
end

return Subsurface
