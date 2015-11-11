--- Freetype mock class
local class = require("lib.classy")
local FreetypeMock = class("FreetypeMock")

-- A constructor of freetype
function FreetypeMock:__init(color, size, position, path)
	self.text = {}
end

-- Save text to instance attribute
function FreetypeMock:draw_over_surface(surface, text)
	table.insert(self.text, text)
end

return FreetypeMock
