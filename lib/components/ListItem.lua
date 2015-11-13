

local class = require("lib.classy")
local View = require("lib.view.View")
local ListItem = class("ListItem", View)
local Font = require("lib.font.Font")
local Color = require("lib.draw.Color")


function ListItem:__init(text_left, font, text_position_left, text_color_selected, enabled, selected)
	View.__init(self)

	--text_right, font_size, font_path, icon
	self.text_left = text_left
	self.text_position_left = text_position_left
	--self.text_right = text_right
  self.font = font
	self.text_color_selected = text_color_selected or text_color
 	self._enabled = enabled or true
  self._selected = selected or false
	self.text_available = false
--	self.font_size = font_size
--	self.font_path = font_path
--  self.icon = icon
end

function ListItem:select(status)
	self._selected = status
end

function ListItem:render(surface)

if self._selected then
	surface:clear({r=0, g=0, b=255, a=255})
else
  surface:clear({r=255, g=255, b=255, a=255})
end

self.font:draw(surface, self.text_position_left, self.text_left)

self:dirty(false)

end

return ListItem
