

local class = require("lib.classy")
local View = require("lib.view.View")
local ListItem = class("ListItem", View)


function ListItem:__init(text_left, text_color, text_color_selected, enabled, selected)
	View.__init(self)

	--text_right, font_size, font_path, icon


	self.text_left = text_left
	self.text_right = text_right
  self.text_color = text_color
	self.text_color_selected = text_color_selected or text_color
 	self._enabled = enabled or true
  self._selected = selected or false
	self.font_size = font_size
	self.font_path = font_path
  self.icon = icon

end

function ListItem:enable(status)
	if status == nil then
		status = true
	end

	local old_status = self._enabled
	self._enabled = status

	self:is_dirty()
end

function ListItem:select(status)
	if status == nil then
		status = true
	end

	local old_status = self._selected
	self._selected = status
	self:is_dirty(true)
end

function Button:is_selected()
	return self._selected
end

function ListItem:render(surface)

-- Skriv här..

end



return ListItem
