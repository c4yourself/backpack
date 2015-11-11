

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

function ListComp:add_ListItem(position, listItem) --ListItem_size behövs den? och button=ListItem? Här vill vi kontrollera att ListComp inte går utanför TravelViews surface
-- check if the button across the screen boundaries
	if position.x >= 0 and button_size.width >= 0
		 and position.x + button_size.width < 1280
		 and position.y >= 0 and button_size.height >= 0
		 and position.y + button_size.height < 720	then
-- if ok, insert each button to the button_list
	 table.insert(self.item_list,
	 {listItem = listItem,
	 x = position.x,
	 y = position.y,
	 width = button_size.width, --ändra
	 height = button_size.height --ändra
	 })

else
	error("screen boundary error")
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

-- Go through the button_list to render all buttons
    for i=1 , #self.item_list do
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

end

end










return ListComp
