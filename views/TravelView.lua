
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
local WorldMap = require("views.WorldMapView")
local button_return = require("lib.components.Button")
local count = 1

local font_dest = Font("data/fonts/DroidSans.ttf", 20, Color(255, 150, 0, 255))


function TravelView:__init(remote_control)
	View.__init(self)

	--	self.route_list = ListComp()
	--	self.route_list:add_list_item(listItem("New york"))
	--	self.route_list:add_list_item(listItem("Tokyo"))
	local callback = utils.partial(self._travel, self)
	self:listen_to(
	event.remote_control,
	"button_release",
	callback
	)

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
list_item_position_left, font_color_selected, true, false)

local list_item3 = ListItem(
icon_train,
"Cairo",
font_color,
list_item_position_left, font_color_selected, true, false)

local list_item4 = ListItem(
icon_plane,
"Tokyo",
font_color,
list_item_position_left, font_color_selected, true, false)

local list_item5 = ListItem(
icon_train,
"Bombay",
font_color,
list_item_position_left, font_color_selected, true, false)

-- text_left, text_right, text_color, text_color_selected, enabled, selected, font_size, font_path, icon hur vi tänkt oss sen

self.list_comp = ListComp()

local position_1 = {x=100,y=50}

self.list_comp:add_list_item(list_item1)
self.list_comp:add_list_item(list_item2)
self.list_comp:add_list_item(list_item3)
self.list_comp:add_list_item(list_item4)
self.list_comp:add_list_item(list_item5)

local list_comp_surface = SubSurface(surface,{width=450, height=300, x=20, y=50})
self.list_comp:render(list_comp_surface)
self.list_comp:on("dirty", function() self.list_comp:render(list_comp_surface); gfx.update() end)

local world_map_surface = SubSurface(surface, {width = 500, height=300, x=577, y=50})
world_map_surface:fill({r=65, g=70, b=72, a=255})
world_map_surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/worldmap1.png")), nil, {x=5, y=5, width=490, height=290})

dest_info_surface = SubSurface(surface, {width = 500, height=100, x=577, y=400})
dest_info_surface:clear({r=65, g=70, b=72, a=255})
font_dest:draw(dest_info_surface, {x = 170, y = 40}, "Paris to " .. self.list_comp.item_list[1].text_left )

print("Detta är icon: " .. self.list_comp.item_list[1].icon)
end


function TravelView:_travel(button)
	if button == "ok" then
		self:stop_listening(event.remote_control)

		local city_view_copy = require("views.CityViewCopy")
		cvc = city_view_copy(event.remote_control)

		local wm = WorldMap()
		local index

		for i = 1, #self.list_comp.item_list, 1 do
			if self.list_comp.item_list[i]._selected == true then
				index = i
			end
		end

		local dest = self.list_comp.item_list[index].text_left

		if dest == "New York" then
			dest = "new_york"
		elseif dest == "Rio de Janeiro" then
			dest = "rio"
		else
			dest = string.lower(dest)
		end

		local transportation = self.list_comp.item_list[index].icon

		if transportation:sub(13,13) == 'a' then
			transportation = "aeroplane"
		elseif transportation:sub(13,13) == 'b' then
			transportation = "boat"
		elseif transportation:sub(13,13) == 't' then
			transportation = "train"
		end

		wm:render(screen, "paris", dest, transportation, cvc )

	elseif button == "4" then
		self:stop_listening(event.remote_control)
		local city_view_copy = require("views.CityViewCopy")
		cvc = city_view_copy(event.remote_control)
		self:destroy()
		cvc:render(screen)
		gfx.update()
	elseif button == "down" or "up" then
		for i = 1, #self.list_comp.item_list, 1 do
			if self.list_comp.item_list[i]._selected == true then
				dest_info_surface:clear({r=65, g=70, b=72, a=255})
				font_dest:draw(dest_info_surface, {x = 170, y = 40}, "Paris to " .. self.list_comp.item_list[i].text_left)
			end
		end
		gfx.update()
	end
end


--[[function TravelView:load_view(button)
if button == "backspace" then
view.view_manager:set_view(city_view_copy)
gfx.update()


end--]]

return TravelView
