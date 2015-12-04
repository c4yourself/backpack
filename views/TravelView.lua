

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local cities = require("lib.city")
local Font = require("lib.draw.Font")
local View = require("lib.view.View")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local SubSurface = require("lib.view.SubSurface")
local List = require("components.List")
local ListItem = require("components.ListItem")
local WorldMap = require("views.WorldMapView")
local city = require("lib.city")

local TravelView = class("TravelView", View)

function TravelView:__init(remote_control, surface, profile)
	View.__init(self)

	self.profile = profile
	self.city = profile:get_city()
	self.routes = self.city.travel_routes

	self.font = Font("data/fonts/DroidSans.ttf", 20, Color(65, 70, 72, 255))
	self.font_highlight = Font("data/fonts/DroidSans.ttf", 20, Color(255, 255, 255, 255))
	self.font_dest = Font("data/fonts/DroidSans.ttf", 20, Color(255, 150, 0, 255))
	self.font_header = Font("data/fonts/DroidSans.ttf", 30, Color(255, 255, 255, 255))

	self.list_comp = List()

	local list_item_position_left = {x=65, y=35}
	local list_item_position_right = {x=375, y=35}

	local travel_type = {
		boat = "data/images/boat.png",
		plane = "data/images/airplane.png",
		train = "data/images/train.png"
	}

	self.image = gfx.loadpng("data/images/worldmap1.png")

	for i = 1, #self.routes do
		local destination = city.cities[self.routes[i][1]]
		local list_item = ListItem(
			destination.name,
			travel_type[self.routes[i][2]],
			self.routes[i][3],
			self.font,
			list_item_position_left,
			list_item_position_right,
			self.font_highlight)

		if i == 1 then
			list_item:select()
		end

		self.list_comp:add_list_item(list_item)
	end

	local callback = utils.partial(self._travel, self)
	self:listen_to(
	event.remote_control,
	"button_release",
	callback
	)

end

function TravelView:render(surface)

	surface:clear({r=0, g=0, b=0, a=255})

	local button_color = {r=255, g=150, b=0, a=255}
	local text_color = {r=0, g=0, b=0}
	local button_size_1 = {width = 500, height = 100}
	local topic_surface = SubSurface(surface, {
		width=surface:get_width(),
		height=surface:get_height(),
		x = 0, y = 0})
	local rectangle = {width=surface:get_width(),
	 height=math.floor(surface:get_height()*0.2),
	 x=0, y=0}
	self.font_header:draw(topic_surface, rectangle, "Travel Agency", "center", "middle")

	--Implements Return Button to City View
	local return_button = SubSurface(surface, {
		width=250, height=100,
		x=22, y=surface:get_height()*0.78})
	return_button:fill(button_color)

	self.font:draw(return_button, {
		width=return_button:get_width(),
		height=return_button:get_height(),
		x=0, y=0},
		"Return to ".. self.city.name, "center", "middle")

	local list_comp_surface = SubSurface(surface,{width=450, height=300,
		x = 20, y = math.floor(surface:get_height()*0.2)})
	self.list_comp:render(list_comp_surface)
	self.list_comp:on("dirty", function() self:render(surface); gfx.update() end)

	local current_destination = city.cities[self.routes[self.list_comp.current_index][1]]

	dest_info_surface = SubSurface(surface, {
		width = 500, height = 100,
		x=577, y=surface:get_height()*0.78})

	dest_info_surface:clear({r=65, g=70, b=72, a=255})

	self.font_dest:draw(dest_info_surface, {
		width=dest_info_surface:get_width(),
		height=dest_info_surface:get_height(),
		x = 0, y = 0},
		self.city.name .. " to " .. current_destination.name, "center", "middle")


	local world_map_surface = SubSurface(surface, {
		width = 500,
		height=300,
		x=577, y=surface:get_height()*0.2})

	world_map_surface:fill({r=65, g=70, b=72, a=255})
	world_map_surface:copyfrom(self.image, nil, {x=5, y=5, width=490, height=290})

	self:dirty(false)
end

function TravelView:_travel(button)
	if button == "ok" then
		self:stop_listening(event.remote_control)

		-- Find index of currently selected travel route
		local index
		for i = 1, #self.list_comp.item_list, 1 do
			if self.list_comp.item_list[i]._selected == true then
				index = i
				break
			end
		end

		-- Find destination city index based on selected city
		local destination = city.cities[self.city.travel_routes[index][1]]

		local transportation = self.list_comp.item_list[index].icon

		if transportation:sub(13,13) == 'a' then
			transportation = "aeroplane"
		elseif transportation:sub(13,13) == 'b' then
			transportation = "boat"
		elseif transportation:sub(13,13) == 't' then
			transportation = "train"
		end

		local world_map = WorldMap(
			self.profile, destination, transportation, view.view_manager)
		view.view_manager:set_view(world_map)
		world_map:start()
	elseif button == "4" then
		self:stop_listening(event.remote_control)
		local city_view_copy = require("views.CityViewCopy")
		cvc = city_view_copy(event.remote_control)
		self:destroy()
		cvc:render(screen)
		gfx.update()

	end
end

return TravelView
