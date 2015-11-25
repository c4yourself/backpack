
local class = require("lib.classy")
local FontMock = class("FontMock")
local FreetypeMock = require("lib.mocks.FreetypeMock")


function FontMock:__init(font_file, size, color)
	self.path = font_path
	self.size = size
	self.color = color

	self.freetype = FreetypeMock(color:to_table("short"), size, {x = 0, y = 0}, font_file)
end


function FontMock:draw(surface, rectangle, text, horizontal_align, vertical_align)
	self.freetype:draw_over_surface(surface, text)
end

return FontMock
