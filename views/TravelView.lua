
local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local View = require("lib.view.View")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local SubSurface = require("lib.view.SubSurface")
local ListItem = require("lib.components.ListItem")
local ListComp =	require("lib.components.ListComp")
local TravelView = class("TravelView", View)

function TravelView:__init(remote_control)
	View.__init(self)

--	self.route_list = ListComp()
--	self.route_list:add_list_item(listItem("New york"))
--	self.route_list:add_list_item(listItem("Tokyo"))

end


function TravelView:render(surface)
--	self.route_list:render(SubSurface())
	surface:clear({r=0, g=0, b=0, a=255})

	local button_color = {r=255, g=150, b=0, a=255}
	local text_color = {r=0, g=0, b=0}
	local button_size_1 = {width=500,height=100}

	--Implements Return Button to City View
	local font = Font("data/fonts/DroidSans.ttf", 20, Color(65, 70, 72, 255))
	local return_button = SubSurface(surface, {width=250, height=100, x=22, y=400})
	return_button:fill(button_color)
	font:draw(return_button, {x=40, y=37}, "Return to City View")

	local list_item_position_left = {x=65, y=35}
--[[
	Efter merge från Development kan följande skrivas för vertikal centrering:

	local list_item_position_left = {x=45, height = surface:get_height()}

]]


	local font_color = Font("data/fonts/DroidSans.ttf", 20, Color(65, 70, 72, 255))
	local font_color_selected = Font("data/fonts/DroidSans.ttf", 20, Color(255, 255, 255, 255))
	local icon_plane = "data/images/airplane.png"
	local icon_boat = "data/images/boat.png"
	local icon_train = "data/images/train.png"


--text_left, font, text_position_left, text_color_selected, enabled, selected
	local list_item1 = ListItem(
		icon_plane,
		"New York",
		font_color,
		list_item_position_left, font_color_selected, true, true)

	local list_item2 = ListItem(
		icon_boat,
		"London",
		font_color,
		list_item_position_left, font_color_selected, true, true)

	local list_item3 = ListItem(
		icon_train,
		"Cairo",
		font_color,
		list_item_position_left, font_color_selected, true, true)

	local list_item4 = ListItem(
		icon_plane,
		"Tokyo",
		font_color,
		list_item_position_left, font_color_selected, true, true)

	local list_item5 = ListItem(
		icon_train,
		"Bombay",
		font_color,
		list_item_position_left, font_color_selected, true, true)

-- text_left, text_right, text_color, text_color_selected, enabled, selected, font_size, font_path, icon hur vi tänkt oss sen

	self.list_comp = ListComp()


  local position_1 = {x=100,y=50}

	self.list_comp:add_list_item(list_item1)
	self.list_comp:add_list_item(list_item2)
	self.list_comp:add_list_item(list_item3)
	self.list_comp:add_list_item(list_item4)
	self.list_comp:add_list_item(list_item5)

--	local font = Font("data/fonts/DroidSans.ttf", 30, Color(255, 0, 0, 255))
--	font:draw(surface, {x=200, y=80}, "Return to City View")

--	local list_surface = SubSurface(surface,{width=350, height=50, x=10, y=5})
--	list_item1:render(list_surface)

	local list_comp_surface = SubSurface(surface,{width=450, height=300, x=20, y=50})
	self.list_comp:render(list_comp_surface)
	self.list_comp:on("dirty", function() self.list_comp:render(list_comp_surface); gfx.update() end)
end

--[[function TravelView:load_view(button)
	if button == "backspace" then
		view.view_manager:set_view(city_view_copy)
		gfx.update()
	end

end--]]

return TravelView
