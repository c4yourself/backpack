local class = require("lib.classy")
local View = require("lib.view.View")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local utils = require("lib.utils")

local ListItem = class("ListItem", View)

function ListItem:__init(text_left, icon, money, font, text_position_left, text_position_right, font_highlight, enabled)
	View.__init(self)

	self.icon = icon
	self.text_left = text_left
	self.money = money
	self.text_position_left = text_position_left
	self.text_position_right = text_position_right
	self.font = font
	self.font_highlight = font_highlight
	self.enabled = enabled

end

function ListItem:select(status)
	self._selected = status
end

function ListItem:render(surface)

	local icon_height = 40

	if self._selected then
		-- Enabled if we can afford, not otherwise
		if self.enabled then
			surface:clear({r=250, g=169, b=0, a=255})
		else
			surface:clear({r=5, g=5, b=5, a=155})
		end

		self.font_highlight:draw(surface, {x = 70, y = 0, height = surface:get_height()},
			self.text_left, "left", "middle")

		self.font_highlight:draw(surface, self.text_position_right, tostring(self.money))


	else
		-- Enabled if we can afford, not otherwise
		if self.enabled then
			surface:clear({r=255, g=150, b=0, a=255})
		else
			surface:clear({r=25, g=25, b=25, a=55})
		end

		self.font:draw(surface, {x = 70, y = 0, height = surface:get_height()}, self.text_left, "left", "middle")
		self.font:draw(surface, self.text_position_right, tostring(self.money))

		--surface:copyfrom(gfx.loadpng(self.icon), nil, {x=15, y=(surface:get_height()/2)-(icon_height/2),
		--	width=40, height=icon_height}, true)
	end

	if self.icon then
	surface:copyfrom(gfx.loadpng(self.icon), nil, {x=15, y=(surface:get_height()/2)-(icon_height/2),
		width=40, height=icon_height}, true)
	end

self:dirty(false)

end

return ListItem
