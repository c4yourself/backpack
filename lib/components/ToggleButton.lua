--- A type of button that can be toggled on or off

local class = require("lib.classy")
local Button = require("lib.components.Button")
local ToggleButton = class("ToggleButton", Button)
local Color = require("lib.draw.Color")

-- Contructor for the ToggleButton class
function ToggleButton:__init(color, color_selected, color_disabled, enabled, selected, transfer_path)
	Button:__init(color, color_selected, color_disabled, enabled, selected, transfer_path)
	self.toggled = false
	self.color_toggled = Color(0,0,255,255)
end

-- Switches the state for the toggle button
function ToggleButton:toggle()
	self.toggled = not self.toggled
	self:trigger("dirty")
end

-- Renders a toggle button
function ToggleButton:render(surface)
	self:dirty(false)

	if self.toggled then
		surface:fill(self.color_toggled:to_table())
	elseif not self:is_enabled() then
		surface:fill(self.color_disabled:to_table())
	elseif self:is_selected() then
		surface:fill(self.color_selected:to_table())
	else
		surface:fill(self.color:to_table())
	end
end

return ToggleButton
