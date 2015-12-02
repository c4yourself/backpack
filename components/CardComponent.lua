--- CardComponent class. The CardComponent class is used for representing cards
-- in the memory mini game. Builds upon the button class.
-- @classmod CardComponent

local class = require("lib.classy")
local View = require("lib.view.View")
local Button = require("lib.components.Button")
local CardComponent = class("CardComponent", Button)
local event = require("lib.event")
local utils = require("lib.utils")
local Color = require("lib.draw.Color")
local SubSurface = require("lib.view.SubSurface")

--- Constructor for CardComponent
-- @param current_city The users current city, used for chosing pictures
-- @param i The cardnumber, used to match pictures
--@param color The color of card's backside
--@param color_selected The color for a selected card
--@param color_disabled The color for a disabled card
--@param enabled The card is enabled or not when instantiating
--@param selected The card is selected or not when instantiating
--@param transfer_path The path for the view after the card is clicked.
--			Note: this isn't currently in use for the cards
function CardComponent:__init(current_city, i, color, color_selected, color_disabled, enabled, selected, transfer_path)
	Button.__init(self, color, color_selected, color_disabled, enabled, selected, transfer_path)
	self.status = "FACING_DOWN"

	-- Colors
	self.backside_color = Color(0,0,0,255)
	self.front_color = Color(255, 255, 255, 255)
	self.from_img = gfx.loadpng("data/images/memory_pictures/generic/memory_question.png")
	self.current_city = current_city:lower()

	if i == 1 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_1.png")
	elseif i == 2 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_2.png")
	elseif i == 3 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_3.png")
	elseif i == 4 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_4.png")
	elseif i == 5 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/generic/memory_boat.png")
	elseif i == 6 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/generic/memory_bus.png")
	elseif i == 7 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/generic/memory_plane.png")
	elseif i == 8 then
		self.memory_img = gfx.loadpng("data/images/memory_pictures/generic/memory_train.png")
	end
	--
	-- if i == 1  or i == 6 then
	-- 	self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_1.png")
	-- elseif i == 2 or i == 5 then
	-- 	self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_2.png")
	-- elseif i == 3 or i == 8 then
	-- 	self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_3.png")
	-- elseif i == 4 or i == 7 then
	-- 	self.memory_img = gfx.loadpng("data/images/memory_pictures/"..self.current_city.."/memory_"..self.current_city.."_4.png")
	-- elseif i == 9 or i == 12 then
	-- 	self.memory_img = gfx.loadpng("data/images/memory_pictures/generic/memory_boat.png")
	-- elseif i == 10 or i == 11 then
	-- 	self.memory_img = gfx.loadpng("data/images/memory_pictures/generic/memory_bus.png")
	-- end
end

--Renders a CardComponent on the specified SubSurface
--@param surface @{Surface} or @{SubSurface} to render on
function CardComponent:render(surface)
	self:dirty(false)
	if self.status == "FACING_UP" then
		surface:copyfrom(self.memory_img)
	elseif self.status == "FACING_DOWN" then
		surface:fill(self.backside_color:to_table())
		surface:copyfrom(self.from_img)
	elseif not self:is_enabled() then
		surface:fill(self.color_disabled:to_table())
	end

	if self:is_selected() then
		local margin = 0.30
		local area = {
			width = surface.width - 17,
			height = 10,
			x = 0,
			y = surface.height - 10
		}
		local sub_surface = SubSurface(surface,area)
		sub_surface:fill(self.color_selected:to_table())
	end
end

--- Sets the card status to be either facing up or facing down. Triggers dirty
-- if the status has changed.
--@param status String representing the new status. May be one of the following
-- 				constants: "FACING_UP", "FACING_DOWN".
function CardComponent:set_card_status(status)
	local old_status = self.status
	if old_status ~= status then
		self.status = status
		self:trigger("dirty")
	end
end

return CardComponent
