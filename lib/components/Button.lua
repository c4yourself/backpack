--- Button class.
-- @classmod Button

local class = require("lib.classy")
local View = require("lib.view.View")

local Button = class("Button", View)

function Button:__init(color, color_selected, color_disabled, enabled, selected)
	View.__init(self)
	self.color = color
	self.color_selected = color_selected or color
	self.color_disabled = color_disabled or color
	self._enabled = enabled or true
	self._selected = selected or false
	self.text_available = false
end

function Button:set_textdata(text, font_color, text_position, font_size,font_path)
  self.text_available = true
	self.text = text
	self.font_size = font_size
	self.font_color = font_color
  self.font_path = font_path
	self.text_position = text_position
end

-- function Button:has_text()
-- 	self.has_text = true
--   return self.has_text
-- end


function Button:enable(status)

	if status == nil then
		status = true
	end

	local old_status = self._enabled
	self._enabled = status

	self:mark_dirty()

end

function Button:is_enabled()
	return self._enabled
end

function Button:select(status)

	if status == nil then
		status = true
	end

	local old_status = self._selected
	self._selected = status
	self:dirty(true)
end

function Button:is_selected()
	return self._selected
end



function Button:render(surface)

	self:dirty(false)

--	if self.disabled then
    if not self:is_enabled() then
		surface:clear(self.color_disabled:to_table())
	elseif self:is_selected() then
		surface:clear(self.color_selected:to_table())
	else
		surface:clear(self.color:to_table())
	end

	--self:display_text(surface) --subsurface is NOT a surface

end


return Button
