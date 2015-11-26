--- Surface mock class
-- @classmod SurfaceMock
local class = require("lib.classy")
local Color = require("lib.draw.Color")
local SurfaceMock = class("SurfaceMock")

--- Constructor for SurfaceMock.
function SurfaceMock:__init(width, height)
	self.width = math.floor(width)
	self.height = math.floor(height)

	local default_color = Color(0, 0, 0, 0)
	self.pixels = {}
	for i= 0, (width-1) do
		self.pixels[i] = {}
		for j = 0, (height-1) do
			self.pixels[i][j] = default_color
		end
	end
end

--- Fills desired area of the surface with a solid color.
function SurfaceMock:clear(color, rectangle)
	local c = Color.from_table(color)
	local rect = self:_get_rectangle(rectangle)

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

--- Blends current color with a desireable color in a speciefied rectangle
function SurfaceMock:fill(color, rectangle)
	local c = Color.from_table(color)
	local rect = self:_get_rectangle(rectangle)

	local w = math.floor(rect.x + rect.width - 1)
	local h = math.floor(rect.y + rect.height - 1)
	for i = rect.x, w do
		for j = rect.y, h do
			--print("this is i: " .. i)
			--print("this is j: " .. j)
			self.pixels[i][j] = self.pixels[i][j]:blend(c)
		end
	end
end

--- Copy pixels from another surface into this
-- Will only work if src_rectangle and dest_rectangle is the same size
function SurfaceMock:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)
	local dest_rect = self:_get_rectangle(dest_rectangle)
	local w = dest_rect.x + dest_rect.width - 1
	local h = dest_rect.y + dest_rect.height - 1

		for i = dest_rect.x, w do
			for j = dest_rect.y, h do
				local c = Color(255, 50, 70, 255)
				self.pixels[i][j] = c
			end
		end
end

--- Get this surface's width
function SurfaceMock:get_width()
	return self.width
end

--- Get this surface's height
function SurfaceMock:get_height()
	return self.height
end

--- Get color of the pixel at location x and y
function SurfaceMock:get_pixel(x, y)
	local r, g, b, a  = self.pixels[x][y]:to_values()
	return {r = r, g = g, b = b, a = a}
end

--- Set color of the pixel at location x and y
function SurfaceMock:set_pixel(x, y, color)
	self.pixels[x][y] = color
end

--- Does nothing, but needed for feature parity with the regular surface class.
function SurfaceMock:premultiply()
end

--- Does nothing, but needed for feature parity with the regular surface class.
function SurfaceMock:destroy()
end

--- Modifies the alpha value of every pixel within this surface
function SurfaceMock:set_alpha(alpha)
	local a = alpha
	for i= 0, (width-1) do
		self.pixels[i] = {}
		for j = 0, (height-1) do
			self.pixels[i][j].a = a
		end
	end
end

--- Locates the desireable rectangle, default is whole surface.
-- @local
function SurfaceMock:_get_rectangle(rectangle)
	local rect = {
		x = 0,
		y = 0,
		width = self.width,
		height = self.height
	}

	if rectangle ~= nil then
		rect.x = math.floor(rectangle.x or 0)
		rect.y = math.floor(rectangle.y or 0)

		if rect.x + (rectangle.width or rectangle.w) <= rect.width then
			rect.width = (rectangle.width or rectangle.w)
		end

		if rect.y + (rectangle.height or rectangle.h) <= rect.height then
			rect.height = (rectangle.height or rectangle.h)
		end
	end
	return rect
end

return SurfaceMock
