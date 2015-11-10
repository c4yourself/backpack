--- A freetype font to be written on a @{emulator.surface|surface}.
--
-- Part of Zenterio Lua API.
--
-- @classmod emulator.freetype
-- @alias freetype

local class = require("lib.classy")
local Color = require("lib.draw.Color")

local freetype = class("freetype")

--- Constructor for freetype
--
-- Used by @{emulator.sys.new_freetype|sys.new_freetype}
--
-- @param color Color of font
-- @param size Size of font in pixels(?)
-- @param position Left upper corner a start point to a drawing text
-- @param path Path to .ttf font
-- @local
function freetype:__init(color, size, position, path)
	self.color = Color.from_table(color)
	self.size = size
	self.position = position
	self.path = path
end

--- Draw text over surface
--
-- @param surface Surface to draw on
-- @param text Text to draw
-- @zenterio
function freetype:draw_over_surface(surface, text)
	surface:_write_text(self, text)
end

return freetype
