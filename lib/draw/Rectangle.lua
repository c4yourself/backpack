--- Simple utility class for working with rectangles. The rectangle knows its
-- x and y position as well as height and width. This is mostly
-- @classmod Color

local class = require("lib.classy")
local utils = require("lib.utils")

local Rectangle = class("Rectangle")

--- Constructor for Rectangle.
-- Returns error on missing or invalid values.
--
-- @param x Zero based X-coordinate of rectangle
-- @param y Zero based Y-coordinate of rectangle
-- @param width Width in pixels
-- @param height Height in pixels
function Rectangle:__init(x, y, width, height)
	if x == nil or y == nil or width == nil or height == nil then
		error("Invalid rectangle, position and size must be provided")
	end

	if x < 0 or y < 0 or width < 1 or height < 1 then
		error("Invalid rectangle, position and size must be positve")
	end

	self.x = x
	self.y = y
	self.width = width
	self.height = height
end

--- Returns starting coordinates (upper left corner)
-- @return x, y
function Rectangle:get_start()
	return self.x, self.y
end

--- Return end coordinates (lower right corner)
-- @return x, y
function Rectangle:get_end()
	return self.x + self.width - 1, self.y + self.width -1
end

--- Checks if given rectangle is completely contained within this rectangle
-- @param rectangle Rectangle instance
-- @return True if given rectangle completely fits within this rectangle, else
--         false.
function Rectangle:contains(rectangle)
	local sex, sey = rectangle:get_end()
	local rx, ry = rectangle:get_start()
	local rex, rey = rectangle:get_end()

	return self.x <= rx and self.y <= ry and sex >= rex and sey >= rey
end

--- Return a table of position and size
-- @return {x = <x>, y = <y>, width = <width>, height = <height>}
function Rectangle:to_table()
	return {
		x = self.x,
		y = self.y,
		width = self.width,
		height = self.height
	}
end

function Rectangle:translate(x, y)
	x = x or 0
	y = y or 0

	return Rectangle(self.x + x, self.y + y, self.width, self.height)
end

function Rectangle:clear(surface, color)
	surface:clear(color:to_table(), self:to_table())
end

function Rectangle:fill(surface, color)
	surface:fill(color:to_table(), self:to_table())
end

--- Return a new Rectangle instance based on a surface.
-- Position is (0, 0)
-- @return New Rectangle with same dimensions as given surface
function Rectangle.from_surface(surface)
	return Rectangle(0, 0, surface:get_width(), surface:get_height())
end

--- Return a new Rectangle instance based on a table in the following format:
--
-- - `{x = 0, y = 0, w = 0, h = 0}`
-- - `{x = 0, y = 0, width = 0, height = 0}`
--
-- @return New rectangle instance according to given rectangle and default
--         rectangle.
function Rectangle.from_table(rectangle, default_rectangle)
	if rectangle == nil then
		rectangle = {}
	end

	if default_rectangle == nil then
		default_rectangle = {}
	end

	local output = {
		x = default_rectangle.x or 0,
		y = default_rectangle.y or 0,
		width = default_rectangle.width or default_rectangle.w,
		height = default_rectangle.height or default_rectangle.h
	}

	output.x = rectangle.x or output.x
	output.y = rectangle.y or output.y
	output.width = rectangle.width or rectangle.w or output.width
	output.height = rectangle.height or rectangle.h or output.height

	return Rectangle(output.x, output.y, output.width, output.height)
end

return Rectangle
