

local class = require("lib.classy")
local View = require("lib.view.View")
local listItem = require("lib.components.ListItem")
local SubSurface = require("lib.view.SubSurface")

local ListComp = class("ListComp",View)

function ListComp:__init()
	View.__init(self)
	self.item_list = {} -- a list contains all ListItems for the view.
	self.start_indicator = true -- will function just once, help to map the indicator with
															-- the selected ListItem when the ListComp is created.
	self.list_indicator = nil

end

function ListComp:add_list_item(list_item) --ListItem_size behövs den? och button=ListItem? Här vill vi kontrollera att ListComp inte går utanför TravelViews surface
	 table.insert(self.item_list, list_item)
end



function ListComp:render(surface)

	if self.start_indicator == true then
		for k = 1 , #self.item_list do
			if self.item_list[k].listItem:is_selected() then
				self.listItem_indicator = k
			end
		end

		if self.listItem_indicator == nil then
			self.listItem_indicator = 1
			self.item_list[1].listItem:select(true)
		end

		self.start_indicator = false
	end

-- Go through the item_list to render all buttons
    for i=1 , #self.item_list do
		local list_data = self.button_list[i]
		local area = {
			width = list_data.width,
			height	=list_data.height,
			x = list_data.x,
			y = list_data.y
		}

		local sub_surface = SubSurface(surface,area)
			list_data.listItem:render(sub_surface)
		if list_data.listItem.text_available then
			self:display_text(surface, i)
		end
	end

end

end










return ListComp
