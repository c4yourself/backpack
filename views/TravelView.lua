

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Font = require("lib.font.Font")
local View = require("lib.view.View")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local SubSurface = require("lib.view.SubSurface")
local listItem = require("lib.components.ListItem")
local listComp =	require("lib.components.ListComp")

local TravelView = class("TravelView", View)

function TravelView:__init(remote_control)
	View.__init(self)

--	self.route_list = ListComp()
--	self.route_list:add_list_item(listItem("New york"))
--	self.route_list:add_list_item(listItem("Tokyo"))

end


function TravelView:render(surface)
--	self.route_list:render(SubSurface())
	surface:clear({r=227, g=111, b=34, a=255})

	local button_color = {r=0, g=128, b=225}
	local text_color = {r=0, g=0, b=0}
	local button_size_1 = {width=500,height=100}

	--Implements Return Button to City View
	surface:fill(button_color, {width=500, height=100, x=100, y=50})

	local list_item1_position_left = {x=20, y=5}
	local list_item2_position_left = {x=20, y=5}
	local list_item1_color_selected = {r=255, g=255, b=255}

	local list_item1 = listItem(
		"New York",
		Font("data/fonts/DroidSans.ttf", 20, Color(255, 0, 0, 255)),
		list_item1_position_left, text_color, list_item1_color_selected,true, true)

	local list_item2 = listItem(
			"London",
			Font("data/fonts/DroidSans.ttf", 20, Color(255, 0, 0, 255)),
			list_item2_position_left, text_color, list_item1_color_selected,true, true)

-- text_left, text_right, text_color, text_color_selected, enabled, selected, font_size, font_path, icon hur vi tänkt oss sen

	self.list_Comp = listComp()

  local position_1 = {x=100,y=50}

	self.list_Comp:add_list_item(list_item1)
	self.list_Comp:add_list_item(list_item2)

	local font = Font("data/fonts/DroidSans.ttf", 30, Color(255, 0, 0, 255))
	font:draw(surface, {x=200, y=80}, "Return to City View")

--	local list_surface = SubSurface(surface,{width=350, height=50, x=10, y=5})
--	list_item1:render(list_surface)

	local list_comp_surface = SubSurface(surface,{width=450, height=300, x=20, y=50})
	self.list_Comp:render(list_comp_surface)
end


return TravelView
