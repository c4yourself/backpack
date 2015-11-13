

local class = require("lib.classy")
local View = require("lib.view.View")
local listItem = require("lib.components.ListItem")
local SubSurface = require("lib.view.SubSurface")
local event = require("lib.event")
local utils = require("lib.utils")

local ListComp = class("ListComp",View)

function ListComp:__init(visible_items)
	View.__init(self)

	self.visible_items = visible_items or 3

	self.item_list = {} 				-- a list contains all ListItems for the view.

	self.start_indicator = true -- will function just once, help to map the indicator with
														-- the selected ListItem when the ListComp is created.
	self.list_indicator = nil

	self:listen_to(event.remote_control, "button_press", utils.partial(self.button_press, self))

	self.current_index = 1

	self.start_index = 1 -- list_item in top of of the visual list

end

function ListComp:button_press(key)
	if key == "up" then
		self.current_index = math.max(self.current_index - 1, 1)
		self:dirty()
	elseif key == "down" then
		self.current_index = math.min(self.current_index + 1, #self.item_list)
		self:dirty()
	end
	print(self.current_index)
end

function ListComp:add_list_item(list_item)
	 table.insert(self.item_list, list_item)
end

function ListComp:render(surface)
	surface:clear({0, 255, 0, 255})

--[[]
	if self.start_indicator == true then
		for k = 1 , #self.item_list do
			print(self.item_list[1])
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

		local height = surface:get_height()/self.visible_items

		for i=1 , self.visible_items do
		local list_data = self.item_list[i]

		if i == self.current_index then
			list_data:select(true)
		else
			list_data:select(false)
		end

		local sub_surface = SubSurface(surface, {
			x = 0, y = (i - 1) * height, width = surface:get_width(), height = height})
		list_data:render(sub_surface)
--		if list_data.listItem.text_available then
--			self:display_text(surface, i)
--		end
	end
	self:dirty(false)
end


return ListComp
