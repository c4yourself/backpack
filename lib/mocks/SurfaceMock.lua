local class = require("lib.classy")
local SurfaceMock = class("SurfaceMock")

--Constructor for SurfaceMock.
function SurfaceMock:__init(width, height)
  SurfaceMock.width = width
  SurfaceMock.height = height
  local c = {
		r = 0,
		g = 0,
		b = 0,
		a = 0
	}
  SurfaceMock.pixels = {}
  for i= 0, (width-1) do
    SurfaceMock.pixels[i] = {}
    for j = 0, (height-1) do
      SurfaceMock.pixels[i][j] = c
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
    width = SurfaceMock.width,
    height = SurfaceMock.height
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
      SurfaceMock.pixels[i][j] = c
    end
  end
end

function SurfaceMock:fill(color, rectangle)
  --TODO iplement function that blend colors in specified rectangle
end

function SurfaceMock:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)
  --TODO implement function that copy pixels from another surface into this one
end

--Get this surface's width
function SurfaceMock:get_width()
  return SurfaceMock.width
end

--Get this surface's height
function SurfaceMock:get_height()
  return SurfaceMock.height
end

--Get color of the pixel at location x and y
function SurfaceMock:get_pixel(x, y)
  return SurfaceMock.pixels[x][y]
end

--Set color of the pixel at location x and y
function SurfaceMock:set_pixel(x, y, color)
 SurfaceMock.pixels[x][y] = color
end

--Does nothing, but needed for feature parity with the regular surface class.
function SurfaceMock:premultiply()
end

--Does nothing, but needed for feature parity with the regular surface class.
function SurfaceMock:destroy()
end

function SurfaceMock:set_alpha(alpha)
  --TODO implemet function that modifies the alpha value for every pixel within this surface
end

return SurfaceMock
