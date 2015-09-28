--- A freetype font to be written on a @{emulator.surface|surface}
-- Part of Zenterio Lua API
-- @classmod emulator.freetype
-- @alias freetype

local class = require("lib.classy")

local freetype = class("freetype")

--- Constructor for freetype
--
-- Used by sys.new_freetype
--
-- @param fontColor Color of font
-- @param fontSize Size of font in pixels(?)
-- @param drawingStartPoint Left upper corner a start point to a drawing text
-- @param fontPath Path to .ttf font
function freetype:__init(fontColor, fontSize, drawingStartPoint, fontPath)
	self.fontColor = fontColor
	self.fontSize = fontSize
	self.drawingStartPoint = drawingStartPoint
	self.fontPath = fontPath
end

--- Draw text over surface
--
-- @param surface Surface to draw on
-- @param text Text to draw
function freetype:draw_over_surface(surface, text)
	love.graphics.setNewFont(self.fontPath, self.fontSize)
	surface:writeOver(text, self.fontColor, self.drawingStartPoint)
end

return freetype
