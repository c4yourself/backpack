

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

function ListComp:add_ListItem(position, button_size, button) --ListItem_size behövs den? och button=ListItem? Här vill vi kontrollera att ListComp inte går utanför TravelViews surface
-- chenck if the button across the screen boundaries
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

end










return ListComp
