--- MemoryGrid class.
-- This class builds on the ButtonGrid class and represents a set of memory cards
-- and buttons in the MemoryView
-- @classmod ButtonGrid

local class = require("lib.classy")
local button = require("lib.components.Button")
local ButtonGrid = require("lib.components.ButtonGrid")
local MemoryGrid = class("MemoryGrid", ButtonGrid)
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local event = require("lib.event")
--local CityView = require("views.CityView")

--- Constructor for ButtonGrid
function MemoryGrid:__init(remote_control)
	ButtonGrid.__init(self)

	self.temp_turned = {}
	self.turned = {}
end

function MemoryGrid:press(button)
	if button == "down" then
		self:indicate_downward(self.button_indicator)
		self:trigger("dirty")
	elseif button == "up" then
		self:indicate_upward(self.button_indicator)
		self:trigger("dirty")
	elseif button == "right" then
		self:indicate_rightward(self.button_indicator)
		self:trigger("dirty")
	elseif button == "left" then
		self:indicate_leftward(self.button_indicator, "left")
		self:trigger("dirty")
	end

	if button == "ok" then
		--TODO make sure it's a card that can be flipped
		self:trigger("submit")
	end
end

function MemoryGrid:render()
-- If no button is selected when this button_grid is created,
-- then the first button in the list will be selected.
-- The indicator always points to the selected button
self:dirty(false)
	if self.start_indicator == true then
		for k = 1 , #self.button_list do
			if self.button_list[k].button:is_selected() then
				self.button_indicator = k
			end
		end

		if self.button_indicator == nil then
			self.button_indicator = 1
			self.button_list[1].button:select(true)
		end

		self.start_indicator = false
  end


-- Go through the button_list to render all buttons
	for i=1 , #self.button_list do
		local button_data = self.button_list[i]
		local area = {
			width = button_data.width,
			height	=button_data.height,
			x = button_data.x,
			y = button_data.y
		}

		local sub_surface = SubSurface(surface,area)
			button_data.button:render(sub_surface)
	  if button_data.button.text_available then
			self:display_text(surface, i)
	   end
   end
   gfx.update()
end


function MemoryGrid:set_card_status(card_index, status)
	self.button_list[i]:set_status(status)
end


return MemoryGrid
