

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
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

end


function TravelView:render(surface)

	surface:clear({r=227, g=111, b=34, a=255})

	local button_color = {r=0, g=128, b=225}
	local text_color = {r=0, g=0, b=0}
	local button_size_1 = {width=500,height=100}
--  local text_button = sys.new_freetype(text_color, 30, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
--	local text_left = {x=100,y=50}

	--Implements Return Button to City View
	surface:fill(button_color, {width=500, height=100, x=100, y=50})

	local list_item1_position_left = {x=10, y=0}
--local list_item1_position_right = {x=0, y=0}
	local list_item1_color_selected = {r=255, g=255, b=255}


	local list_item1 = ListItem("New York", list_item1_position_left, text_color, list_item1_color_selected,true, true)

-- text_left, text_right, text_color, text_color_selected, enabled, selected, font_size, font_path, icon hur vi tänkt oss sen

	self.list_Comp = listComp()

  local position_1 = {x=100,y=50}

	self.list_Comp:add_list_item(list_item1)

	local font = Font("data/fonts/DroidSans.ttf", 10, Color(255, 0, 0, 255))
	font:draw(surface, {x=200, y=80}, "Return to City View")

end


return TravelView
