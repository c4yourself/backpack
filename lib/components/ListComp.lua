

local class = require("lib.classy")
local View = require("lib.view.View")
local list_item = require("lib.components.ListItem")
local SubSurface = require("lib.view.SubSurface")
local event = require("lib.event")
local utils = require("lib.utils")

local ListComp = class("ListComp",View)

function ListComp:__init(visible_items)
	View.__init(self)

	self.visible_items = visible_items or 3

	self.item_list = {} 				-- a list contains all ListItems for the view.

--	self.start_indicator = true -- will function just once, help to map the indicator with
														  -- the selected ListItem when the ListComp is created.
--	self.list_indicator = nil

	self:listen_to(event.remote_control, "button_press", utils.partial(self.button_press, self))

	self.current_index = 1

	self.start_index = 1 -- list_item in top of of the visual list

end

function ListComp:button_press(key)
	if key == "up" then
		self.current_index = math.max(self.current_index - 1, 1)
		if self.current_index < self.start_index then
			self.start_index = self.current_index
		end

		--if self.current_index < self.visible_items then
		--	self.start_index = 1
		--else
		--	self.start_index = self.current_index - (self.visible_items - 1)
		--end

		self:dirty()
	elseif key == "down" then
		self.current_index = math.min(self.current_index + 1, #self.item_list)

		if self.current_index > self.visible_items then
			self.start_index = self.current_index - (self.visible_items - 1)
		end

		self:dirty()
	end

end

function ListComp:add_list_item(list_item)
	 table.insert(self.item_list, list_item)
end

function ListComp:render(surface)
	--surface:clear({0, 75, 153, 255})
	surface:clear({65, 70, 72, 255})
	surface:clear({255, 255, 255, 255},
	{x = 5, y = 5, width = surface:get_width() - 10, height = surface:get_height() - 10})

--[[]
	if self.start_indicator == true then
		for k = 1 , #self.item_list do
			if self.item_list[k]:is_selected() then
				self.list_indicator = k
			end
		end

		if self.listItem_indicator == nil then
			self.listItem_indicator = 1
			self.item_list[1].listItem:select(true)
		end

		self.start_indicator = false
	end
]]

-- Go through the item_list to render all list_items
	local height = (surface:get_height() - 12 - self.visible_items) /self.visible_items


	for i = self.start_index , self.start_index + self.visible_items - 1 do
		local list_data = self.item_list[i]

		if i == self.current_index then
			list_data:select(true)
		else
			list_data:select(false)
		end

	--[[
	 if self.current_index > 3 then
  		if item_list.getn() == i then
			for j = self.current_index, 1 do
				self.item_list[j-1] = self.item_list[j]
				j = j - 1
				tmp = tmp - 1
				if tmp == 0 then break end
			end
		end
]]

		local sub_surface = SubSurface(surface, {
			x = 6, y = 6 + (i - self.start_index) * (height + 1), width = surface:get_width() - 12, height = height})
		  list_data:render(sub_surface)
--		if list_data.listItem.text_available then
--			self:display_text(surface, i)
--		end

  end
	self:dirty(false)
end


return ListComp
