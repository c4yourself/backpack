--- Base class for CityView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CityVie

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local Store = class("Store", view.View)
local BackEndStore = require("lib.store.BackEndStore")
local Profile = require("lib.profile.Profile")
local event = require("lib.event")
local logger = require("lib.logger")
local utils = require("lib.utils")
local SubSurface = require("lib.view.SubSurface")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local Button = require("lib.components.Button")
local ButtonGrid=require("lib.components.ButtonGrid")

-- Get size of Table
local function get_size(a)
	i = 0
	for _ in pairs(a) do i = i+1 end
	return i
end

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function Store:__init(remote_control, city, profile)
	View.__init(self)
	self.background_path = ""
	self.current_city = city
	self.button_grid = ButtonGrid(remote_control)
	self.cashier = gfx.loadpng("data/images/cashier1.png")
	self.shelf = gfx.loadpng("data/images/shelf.png")
	self.backendstore = BackEndStore()
	self.profile = profile
	-- Some colors
	self.background_color = Color{255, 255, 204, 255}
	local button_active = Color{255, 51, 51, 255}
	local button_inactive = Color{255, 153, 153, 255}

	-- Creates local variables for height and width
	local height = screen:get_height()
	local width = screen:get_width()

	-- Get the items relevant for the current city
	self.items = self.backendstore:returnItemList(self.current_city)
	local button_size = {width = 4*width/45, height = 4*width/45}

	-- Create some buttons
	local buttons = {}
	buttons[1] = Button(button_inactive, button_active, button_inactive, true, true)
	k = 2
	while k <= get_size(self.items) do
			buttons[k] = Button(button_inactive, button_active, button_inactive, true, false)
			k = k + 1
	end

	-- Add them to button grid
	row = 1
	j = 1
	while j <= get_size(self.items) do
		self.button_grid:add_button({x = width/2+70+(j-1-4*(row-1))*130,y = 100 + 140*(row-1)}, button_size, buttons[j])
		j = j + 1
		if (j-1) % 4 == 0 then
			row = row + 1
		end
	end
	--[[
	local button1 = Button(button_inactive, button_active, button_inactive, true, true)
	local button2 = Button(button_inactive, button_active, button_inactive, true, true)
	self.button_grid:add_button({x = 50, y = 50}, button_size, button1)
	self.button_grid:add_button({x = 50, y = 100}, button_size, button2)
	]]
	self.add_view(self.button_grid, false)

	self:listen_to(event.remote_control, "button_press", function() self:dirty() end)

end

function Store:dirty(status)
	print("Snuysk")
	View.dirty(self, status)
end

function Store:render(surface)
	-- Creates local variables for height and width
	local height = screen:get_height()
	local width = screen:get_width()

	-- Resets the surface and draws the background
	surface:clear(self.background_color)
	surface:copyfrom(self.cashier, nil, {x = 0, y = 100}, true)
	surface:copyfrom(self.shelf, nil, {x=width/2,y=100}, true)

	print("beofre render")
	self.button_grid:render(surface)
	print("before callback")
	-- Instance remote control and mapps it to the buttons
	local callback = utils.partial(self.load_view, self)
	print("before listen to")
	self:listen_to(
		event.remote_control,
		"button_release",
		callback
		--utils.partial(self.load_view, self)
	)
	print("self time")
	self:dirty(false)
end

function Store:load_view(button)


end

return Store
