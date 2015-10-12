local class = require("lib.classy")

local Subsurface = class("Subsurface")


function Subsurface:__init(surface, area)
	self.surface = surface
  self.rectangle = area
  self.x = area.x
  self.y = area.y
  self.width = area.width
  self.height = area.height
end

function Subsurface:clear(color)

  local c = {
		r = 0,
		g = 0,
		b = 0,
		a = 0
	}

	if color ~= nil then
		c.r = color.r or 0
		c.g = color.g or 0
		c.b = color.b or 0
		c.a = color.a or 255
	end

  for i = self.x, self.width do
		for j = self.y, self.height do
			self.surface.image_data:setPixel(i, j, c.r, c.g, c.b, c.a)
		end
	end

end

function Subsurface:set_pixel(x, y, color)
	self.image_data:setPixel(x, y, color.r, color.g, color.b, color.a)
end

return Subsurface
