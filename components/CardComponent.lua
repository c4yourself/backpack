--- Base class for NumericalInputComponent
--
-- @classmod NumericalInputComponent

local class = require("lib.classy")
local View = require("lib.view.View")
local Button = require("lib.components.Button")
local CardComponent = class("CardComponent", Button)
local event = require("lib.event")
local utils = require("lib.utils")
local Color = require("lib.draw.Color")
local SubSurface = require("lib.view.SubSurface")

--- Constructor for NumericalInputComponent
-- @param event_listener Remote control to listen to
function CardComponent:__init(color, color_selected, color_disabled, enabled, selected, transfer_path)
	Button.__init(self, color, color_selected, color_disabled, enabled, selected, transfer_path)
	self.status = "FACING_DOWN"

	-- Colors
	self.backside_color = color
	self.front_color = Color(255, 255, 255, 255)
end

function CardComponent:render(surface)
	self:dirty(false)
	if self.status == "FACING_UP" then
		surface:fill(self.front_color:to_table())
	elseif self.status == "FACING_DOWN" then
		surface:fill(self.backside_color:to_table())
	elseif not self:is_enabled() then
		surface:fill(self.color_disabled:to_table())
	end

	if self:is_selected() then
		local margin = 0.30
		local area = {
			width = math.ceil((1-2*margin) * surface.width),
			height = math.ceil((1-2*margin) * surface.width),
			x = math.ceil(surface.width * 0.30),
			y = math.ceil(surface.height * 0.30)
		}
		local sub_surface = SubSurface(surface,area)
		sub_surface:fill(self.color_selected:to_table())
	end
end

function CardComponent:set_card_status(status)
	local old_status = self.status
	if old_status ~= status then
		self.status = status
		self:trigger("dirty")
	end
end

return CardComponent
