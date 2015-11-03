local class = require("lib.classy")
local SurfaceMock = class("SurfaceMock")

--Constructor for SurfaceMock.
function SurfaceMock:__init(width, height)
  self.width = width
  self.height = height
  local c = {
		r = 0,
		g = 0,
		b = 0,
		a = 0
	}
  self.pixels = {}
  for i= 0, (width-1) do
    self.pixels[i] = {}
    for j = 0, (height-1) do
      self.pixels[i][j] = c
    end
  end
end

--Fills desired area odf the surface with a solid color.
function SurfaceMock:clear(color, rectangle)
  --Set the color to the required color, default is black.
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

  --locates the desireable rectangle, default is whole surface.
  local rect = {
    x = 0,
    y = 0,
    width = self.width,
    height = self.height)
  }

  if rectangle ~= nil then
    rect.x = (rectangle.x or 0)
    rect.y = (rectangle.y or 0)

    if rect.x + (rectangle.width or rectangle.w) <= rect.width then
      rect.width = (rectangle.width or rectangle.w)
    end

    if rect.y + (rectangle.height or rectangle.h) <= rect.height then
      rect.height = (rectangle.height or rectangle.h)
    end
  end

  --Change color on the specified rectangle, default whole surface gets
  --repainted.
  local w = rect.x + rect.width - 1
  local h = rect.y + rect.height - 1
  for i = rect.x, w do
    for j = rect.y, h do
      self.pixels[i][j] = c
    end
  end
end

--Get this surface's width
function SurfaceMock:get_width()
  return self.width
end

--Get this surface's height
function SurfaceMock:get_height()
  return self.height
end

--Get color of the pixel at location x and y
function SurfaceMock:get_pixel(x, y)
  return self.pixels[x][y]
end

--Set color of the pixel at location x and y
function SurfaceMock:set_pixel(x, y, color)
 self.pixels[x][y] = color
end

return SurfaceMock
