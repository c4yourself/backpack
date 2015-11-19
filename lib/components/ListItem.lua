

local class = require("lib.classy")
local View = require("lib.view.View")
local ListItem = class("ListItem", View)
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local utils = require("lib.utils")


function ListItem:__init(icon, text_left, font, text_position_left, text_color_selected, enabled, selected)
	View.__init(self)

	--text_right, font_size, font_path, icon
	self.icon = icon
	self.text_left = text_left
	self.text_position_left = text_position_left
	--self.text_right = text_right
  self.font = font
  self.text_color_selected = text_color_selected
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
		surface:clear({r=250, g=169, b=0, a=255})
		self.text_color_selected:draw(surface, self.text_position_left, self.text_left)
		surface:copyfrom(gfx.loadpng(self.icon), nil, {x=10, y=28, width=40, height=40})


else
--  surface:clear({r=255, g=255, b=255, a=255})
		surface:clear({r=255, g=150, b=0, a=255})
		self.font:draw(surface, self.text_position_left, self.text_left)
		--[[Efter merge från Development kan följande skrivas för vertikal centrering:

			self.font:draw(surface, self.text_position_left, self.text_left, nil, "middle")

		]]
		surface:copyfrom(gfx.loadpng(self.icon), nil, {x=10, y=28, width=40, height=40})

end

--self.font:draw(surface, self.text_position_left, self.text_left)

self:dirty(false)

end

return ListItem
