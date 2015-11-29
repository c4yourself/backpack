-- The view class store
-- @classmod Store
local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local ProfileView = class("ProfileView", view.View)
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
local ProfileManager = require("lib.profile.ProfileManager")

-- Get size of Table
-- @param a Is the table to get ther size of
local function get_size(a)
	i = 0
	for _ in pairs(a) do i = i+1 end
	return i
end

--- Constructor for Store
-- @param event_listener Remote control to listen to
function ProfileView:__init(remote_control, surface, profile)
	-- Add some internal variables that we will want to use later
	View.__init(self)
	self.surface = surface
	self.background_path = ""
	self.current_city = profile:get_city().name
	self.button_grid = ButtonGrid(remote_control)
	self.backpack = gfx.loadpng("data/images/backpack.png")
	self.backendstore = BackEndStore()
	self.profile = profile
	self.remote_control = remote_control
	self.item_positions = {}
	self.item_images = {}
	self.message = {["message"] = "Select item to purchase or sell"}

	-- Some colors
	self.background_color = Color(255, 255, 255, 255)
	self.button_active = Color(255, 51, 51, 255)
	self.button_inactive = Color(255, 153, 153, 255)

	-- Creates local variables for height and width
	local height = self.surface:get_height()
	local width = self.surface:get_width()

	-- Get the profiles backpack items
	self.backpack_items = self.backendstore:returnBackPackItems(self.profile:get_inventory())

	-- Create the number of buttons that correspond to items in backpack
	self.button_size = {width = 2.5*width/45, height = 2.5*width/45}

	self.buttons = {}
	self.buttons[1] = Button(self.background_color, self.button_active, self.background_color, true, true, 1)
	k = 1
	while k <= get_size(self.backpack_items) do
			self.buttons[k+1] = Button(self.background_color, self.button_active, self.background_color, true, false,k+1)
			k = k + 1
	end

	-- Add the exit button
	self.font = Font("data/fonts/DroidSans.ttf", 20, Color(0, 0, 0, 255))
	self.header_font = Font("data/fonts/DroidSans.ttf", 40, Color(0,0,0,255))
	self.buttons[1]:set_textdata("Exit",Color(255,255,0,255), {x = 30, y = 300}, 20, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Add them to button grid at the correct place

	-- Add exit button
	self.button_grid:add_button({x = width/6,y = height-60}, {width = 6*width/45,height = 2*width/45}, self.buttons[1])

	row = 1
	j = 1
	own_items = 0
	while j <= get_size(self.backpack_items) do
		self.item_positions[j+1] = {x = width/2-100+((j-1)-2*(row-1))*130+own_items*185,
																y = 30 + 105*(row-1-0.8*own_items) + own_items*205}
		self.button_grid:add_button(self.item_positions[j+1], self.button_size, self.buttons[j+1])
		j = j+1
		if (j-1) % 2 == 0 then
			row = row + 1
		end
	end

	-- Create list of item images
	--self.item_images = self:loadItemImages()

	-- Add to view
	self.add_view(self.button_grid, false)

	-- Some fix for movement
	--self:listen_to(event.remote_control, "button_release", function() self:dirty() end)
	local button_render = function()
		self:render(self.surface)
		gfx.update()
	end

	self:listen_to(self.button_grid,"dirty",button_render)

	-- Function that makes us exit when pressing the correct button
	local button_callback = function(button)

		-- Get the current index of button that is selected
		selected_index = button.transfer_path
		local exit = false

		-- Check if we're about to exit
		if selected_index == 1 then
			exit = true
		end

		if exit then
			self:destroy()
			self:trigger("exit_view")
		end

	end

	-- Instance remote control and mapps it to pressing enter
	self:listen_to(self.button_grid,"button_click",	button_callback)

end

-- Load all the images for the items
-- @param none
function ProfileView:loadItemImages()
	local ret_list = {}

	if #self.backpack_items>0 then
		for j = 1, get_size(self.backpack_items) do
			ret_list[j] = gfx.loadpng(self.backpack_items[j]:get_image_path())
		end
	end


	return ret_list

end

-- Render view function
-- @param surface is the surface to draw on
function ProfileView:render(surface)


	-- Creates local variables for height and width
	local height = self.surface:get_height()
	local width = self.surface:get_width()

		-- Resets the surface and draws the background
	surface:clear(self.background_color:to_table())

	--surface:copyfrom(self.backpack, nil, {x=3*width/4, y = 50}, true)

	-- Print the buttons
	--self.button_grid:render(surface)

	-- Print the items
	--[[
	for i = 1, #self.item_images do
		surface:copyfrom(self.item_images[i], nil, self.item_positions[i+1], true)
	end

	--Draw header
	self.header_font:draw(surface, {x=10,y=10}, "Your profile")

	self.font:draw(surface, {x=10,y=40}, "Name: ")
	self.font:draw(surface, {x=50, y = 40}, self.profile:get_name())
	]]
end


-- Function to destory images
function ProfileView:destroy()
  view.View.destroy(self)
  for k,v in pairs(self.item_images) do
     self.item_images[k]:destroy()
  end
	self.backpack:destroy()
end

return ProfileView
