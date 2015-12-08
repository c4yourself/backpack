--- Simple utility class for working with rectangles. The rectangle knows its
-- x and y position as well as height and width. This is mostly
-- @classmod Font

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local logger = require("lib.logger")
local utils = require("lib.utils")
local Rectangle = require("lib.draw.Rectangle")

-- Cache for font objects to make sure they are never garbage collected. This
-- object should be made in the top level module, but code exists here too as a
-- backup.
if not font_cache then
	font_cache = {}
end

local Font = class("Font")

--- Constructor for Font.
-- @param font Path to TTF file. May be either relative or absolute
-- @param size Font size in pixels
-- @param color A @{Color} instance
function Font:__init(font_file, size, color)
	-- Use absolute font paths since two different paths can point to the same
	-- file. This is important for a canonical cache key.
	local font_path = utils.absolute_path(font_file)

	-- Create a key for this font combination. This is used for a global cache
	-- that prevents garbage collection of freetype instances.
	local font_key = string.format("%s:%s:%s", font_path, size, color:to_html())

	self.path = font_path
	self.size = size
	self.color = color

	-- If this font comibination was not found in cache, create it and store in
	-- cache.
	if font_cache[font_key] == nil then
		logger.trace("Creating new freetype for font:", font_path)

		-- Note that color:to_table() can not be used because the freetype object
		-- for some
		font_cache[font_key] = sys.new_freetype(
			color:to_table("short"), size, {x = 0, y = 0}, font_path)
	end

	-- Get freetype instance from cache
	self.freetype = font_cache[font_key]

	-- Calculate baseline to use for aligning and source surface height
	self._glyph_properties = self:_get_glyph_properties()
end

--- Renders the given text on a new surface.
-- @return A new surface with the given text rendered on it.
-- @local
function Font:_get_text_surface(text, width)
	if width == nil then
		-- Default to the greatest probable size, based on the width of "M"
		width = math.max(
			#text * self._glyph_properties.width + self._glyph_properties.left+8,
			screen:get_width())
	end

	-- Calculate a sane default height
	local height = math.min(
		2 * self.size,
		self.size * 2, screen:get_height())

	-- Create a surface to render font to
	local surface = gfx.new_surface(width, height)

	-- Needed since the surface is not necessarily clean. It can be a previously
	-- destroyed surface, or garbage memory.
	surface:clear({0, 0, 0, 0})

	self.freetype:draw_over_surface(surface, text)

	return surface
end

function Font:_get_glyph_properties()
	-- Write a capital M to determine baseline, top offset and width
	local surface = self:_get_text_surface("M", self.size)
	local bbox = self:_get_bounding_box(surface)
	surface:destroy()

	if bbox == nil then
		return nil
	else
		return {
			top = bbox.min_y,
			bottom = bbox.max_y,
			left = bbox.min_x,
			right = bbox.max_x,
			width = bbox.max_x - bbox.min_x,
			height = bbox.max_y - bbox.min_y
		}
	end
end

function Font:_get_bounding_box(surface)
	local min_x, min_y = surface:get_width() - 1, surface:get_height() - 1
	local max_x, max_y = 0, 0

	-- Use knowledge of glyph dimensions to prevent bounding box search from
	-- exiting early when processing split letters like i and j
	local min_y_offset = self._glyph_properties and
		self._glyph_properties.bottom or 0

	-- Keep track of number of iterations required to find bounding box
	local iterations = 0

	-- Search for bounding box
	for y = 0, surface:get_height() - 1 do
		local found_pixels = false

		-- Find minimum x value from left to right
		for x = 0, surface:get_width() - 1 do
			iterations = iterations + 1

			-- If alpha value is not 0 we assume we have found text
			local c = surface:get_pixel(x, y)
			if c.r > 0 or c.g > 0 or c.b > 0 or c.a > 0 then
				min_x = math.min(min_x, x)
				max_x = math.max(max_x, x)

				found_pixels = true
				break
			end
		end

		-- Find maximum x value if we found pixels on this line. Search from
		-- right to left
		if found_pixels then
			for x = surface:get_width() - 1, max_x, -1 do
				iterations = iterations + 1

				-- If alpha value is not 0 we assume we have found text
				local c = surface:get_pixel(x, y)
				if c.r > 0 or c.g > 0 or c.b > 0 or c.a > 0 then
					max_x = math.max(max_x, x)
					found_pixels = true
					break
				end
			end
		end

		-- Update y-values if we found pixels when searching horizontally
		if found_pixels then
			min_y = math.min(min_y, y)
			max_y = math.max(max_y, y)
		end

		if not found_pixels and y > min_y_offset and min_x <= max_x and min_y <= max_y then
			break
		end
	end

	-- Only return bounding box if we actually found something
	if min_x <= max_x and min_y <= max_y then
		local bbox = {
			min_x = min_x,
			min_y = min_y,
			max_x = max_x,
			max_y = max_y
		}

		logger.trace(
			"Found text bounding box in " .. iterations .. " iterations", bbox)
		return bbox
	else
		logger.error("Bounding box not found")
	end
end

function Font:get_bounding_box(text)
	local surface = self:_get_text_surface(text)
	local bbox = self:_get_bounding_box(surface)
	surface:destroy()

	return bbox
end


--- Draw this `text` on the given `surface` relative to the given `rectangle`.
-- `horizontal_align` and `vertical_align` can be used to position the text
-- withing the rectangle.
--
-- @param surface Surface to draw on.
-- @param rectangle Rectangle to draw relative to. The rectangle's X and Y
--                  coordinate determines where on the surface the text should
--                  be drawn. The rectangle width and height determines the
--                  maximum width and height the text will occupy. This is mostly
--                  used in conjunction with horizontal and vertical alignment.
--                  The alignment options work relative to the rectangle.
-- @param text Text to draw
-- @param[opt] horizontal_align Horizontal alignment relative to the rectangle.
--                              May be left, center or right. Default value is
--                              left.
-- @param[opt] vertical_align Vertical alignment relative to the rectangle. May
--                            be top, middle or bottom. Default value is top.
function Font:draw(surface, rectangle, text, horizontal_align, vertical_align)
	-- Don't draw empty text strings
	if text:gsub(" ", "") == "" then
		logger.debug("Skipping drawing of empty text. This might be an error")
		return
	end

	local text_surface = self:_get_text_surface(text)
	local bbox

	local x
	if horizontal_align == nil or horizontal_align == "left" then
		x = 0
	elseif horizontal_align == "center" then
		logger.trace("Calculating bounding box for '" .. text .. "'")
		bbox = bbox or self:_get_bounding_box(text_surface)
		x = math.max(0, rectangle.width / 2 - bbox.max_x / 2)
	elseif horizontal_align == "right" then
		logger.trace("Calculating bounding box for '" .. text .. "'")
		bbox = bbox or self:_get_bounding_box(text_surface)
		x = math.max(0, rectangle.width - bbox.max_x)
	else
		error(
			"Invalid horizontal alignment '" .. horizontal_align .. "', " ..
			"expected left, center or right")
	end

	local y
	if vertical_align == nil or vertical_align == "top" then
		y = 0
	elseif vertical_align == "middle" then
		local glyph_data = self._glyph_properties
		y = math.max(
			0,
			rectangle.height / 2 - (glyph_data.bottom - glyph_data.top) / 2 - glyph_data.top)
	elseif vertical_align == "bottom" then
		logger.trace("Calculating bounding box for '" .. text .. "'")
		bbox = bbox or self:_get_bounding_box(text_surface)
		y = math.max(0, rectangle.height - 1 - bbox.max_y)
	else
		error(
			"Invalid vertical alignment '" .. vertical_align .. "', " ..
			"expected top, middle or bottom")
	end

	local text_rectangle = Rectangle(
		0,
		0,
		math.min(text_surface:get_width(), rectangle.width or text_surface:get_width()),
		math.min(text_surface:get_height(), rectangle.height or text_surface:get_height()))

	surface:copyfrom(
		text_surface,
		text_rectangle:to_table(),
		text_rectangle:translate(x, y):translate(rectangle.x, rectangle.y):to_table(),
		true)

	text_surface:destroy()
end

return Font
