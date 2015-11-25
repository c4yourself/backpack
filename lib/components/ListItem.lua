

local class = require("lib.classy")
local View = require("lib.view.View")
local ListItem = class("ListItem", View)
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local utils = require("lib.utils")


function ListItem:__init(text_left, icon, money, font, text_position_left, text_position_right, font_highlight)
	View.__init(self)

	self.icon = icon
	self.text_left = text_left
	self.money = money
	self.text_position_left = text_position_left
	self.text_position_right = text_position_right
	self.font = font
	self.font_highlight = font_highlight
	
end

function ListItem:select(status)
	self._selected = status
end

function ListItem:render(surface)

	local icon_height = 40

	if self._selected then
		surface:clear({r=250, g=169, b=0, a=255})

		self.font_highlight:draw(surface, {x = 70, y = 0, height = surface:get_height()},
			self.text_left, "left", "middle")

		self.font_highlight:draw(surface, self.text_position_right, tostring(self.money))
		surface:copyfrom(gfx.loadpng(self.icon), nil, {x=15, y=(surface:get_height()/2)-(icon_height/2),
			width=40, height=icon_height})

	else
		surface:clear({r=255, g=150, b=0, a=255})
		self.font:draw(surface, {x = 70, y = 0, height = surface:get_height()}, self.text_left, "left", "middle")
		self.font:draw(surface, self.text_position_right, tostring(self.money))

		surface:copyfrom(gfx.loadpng(self.icon), nil, {x=15, y=(surface:get_height()/2)-(icon_height/2),
			width=40, height=icon_height})

end

self:dirty(false)

end

return ListItem
