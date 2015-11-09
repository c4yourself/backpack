--- Simple utility class for working with rectangles. The rectangle knows its
-- x and y position as well as height and width. This is mostly
-- @classmod Font

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local logger = require("lib.logger")
local utils = require("lib.utils")
local Rectangle = require("lib.draw.Rectangle")

-- Cache for font objects to make sure they are never garbage collected
local font_cache = {}

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

	-- If this font comibination was not found in cache, create it and store in
	-- cache.
	if font_cache[font_key] == nil then
		logger.trace("Creating new freetype for font:", font_path)
		font_cache[font_key] = sys.new_freetype(
		color:to_table(), size, {x = 0, y = 0}, font_path)
	end

	-- Get freetype instance from cache
	self.freetype = font_cache[font_key]
end

--- Renders the given text on a new surface.
-- @return A new surface with the given text rendered on it.
-- @local
function Font:_get_text_surface(text)
	--local surface = gfx.new_surface(screen:get_width(), screen:get_height())
	local surface = gfx.new_surface(200, 200)
	--surface:clear({0, 255, 0, 255})
	self.freetype:draw_over_surface(surface, text)
	return surface
end

function Font:_get_bounding_box(surface)
	local min_x, min_y = surface:get_width() - 1, surface:get_height() - 1
	local max_x, max_y = 0, 0

	-- Search for bounding box
	local default_color = Color(0, 0, 0, 0)
	for y = 0, surface:get_height() - 1 do
		local found_pixels = false
		for x = 0, surface:get_width() - 1 do
			local current_color = Color(surface:get_pixel(x, y))

			if current_color ~= default_color then
				min_x = math.min(min_x, x)
				min_y = math.min(min_y, y)

				max_x = math.max(max_x, x)
				max_y = math.max(max_y, y)

				found_pixels = true
			end
		end

		if not found_pixels and min_x <= max_x and min_y <= max_y then
			break
		end
	end

	-- Only return bounding box if we actually found something
	if min_x <= max_x and min_y <= max_y then
		return {min_x, min_y, max_x, max_y}
	end
end

function Font:get_bounding_box(text)
	local surface = self:_get_text_surface(text)
	local bbox = self:_get_bounding_box(surface)
	surface:destroy()

	return bbox
end

function Font:draw(surface, location, text)
	local text_surface = self:_get_text_surface(text)

	surface:copyfrom(
		text_surface,
		Rectangle.from_surface(text_surface),
		location,
		true)

	text_surface:destroy()
end

return Font
