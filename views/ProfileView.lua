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
	self.room = gfx.loadpng("data/images/hotel_room.png")
	self.backendstore = BackEndStore()
	self.profile = profile
	self.remote_control = remote_control
	self.item_positions = {}
	self.item_images = {}
	self.message = {["message"] = "Select item to purchase or sell"}

	-- Get correct profile picture
	if profile:get_sex() == "male" or profile:get_sex() == "Male" or
		 profile:get_sex() == "m" or profile:get_sex() == "M" then
		self.profile_picture = gfx.loadpng("data/images/male_player.png")
	elseif profile:get_sex() == "female" or profile:get_sex() == "Female" or
		 profile:get_sex() == "f" or profile:get_sex() == "F" then
		self.profile_picture = gfx.loadpng("data/images/female_player.png")
	else
		self.profile_picture = gfx.loadpng("data/images/female_player.png")
	end

	-- Some colors
	self.background_color = Color(255, 255, 255, 255)
	self.button_active = Color(255, 51, 51, 255)
	self.button_inactive = Color(255,255,255,0)
	self.exit_inactive = Color(255, 153, 153, 255)

	-- Creates local variables for height and width
	local height = self.surface:get_height()
	local width = self.surface:get_width()
	--print("The height is: "..height.." and the width is: "..width)
	-- 1152, 603, 829

	-- Get the profiles backpack items
	self.backpack_items = self.backendstore:returnBackPackItems(self.profile:get_inventory())


	-- Create the number of buttons that correspond to items in backpack
	self.button_size = {width = 2.5*width/45, height = 2.5*width/45}

	self.buttons = {}
	self.buttons[1] = Button(self.exit_inactive, self.button_active, self.exit_inactive, true, true, 1)
	k = 1
	while k <= get_size(self.backpack_items) do
			self.buttons[k+1] = Button(self.button_inactive, self.button_active, self.button_inactive, true, false,k+1)
			k = k + 1
	end

	-- Add the exit button
	self.font = Font("data/fonts/DroidSans.ttf", 20, Color(0, 0, 0, 255))
	self.header_font = Font("data/fonts/DroidSans.ttf", 40, Color(0,0,0,255))
	self.buttons[1]:set_textdata("Exit",Color(255,255,0,255), {x = 30, y = 300}, 20, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Add them to button grid at the correct place

	-- Add exit button
	self.button_grid:add_button({x = 162-3*width/45,y = height-60}, {width = 6*width/45,height = 2*width/45}, self.buttons[1])

	row = 1
	j = 1
	own_items = 0
	while j <= get_size(self.backpack_items) do
		self.item_positions[j+1] = {x = 10+(j-1)*(self.button_size.width+15),
																y = 295}
		--[[self.item_positions[j+1] = {x = width/2+20+((j-1)-2*(row-1))*130,
																y = 320}]]
		self.button_grid:add_button(self.item_positions[j+1], self.button_size, self.buttons[j+1])
		j = j+1
	end

	-- Create list of item images
	--self.item_images = self:loadItemImages()

	-- Add to view
	self.add_view(self.button_grid, false)

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
	self.item_images = self:loadItemImages()

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

	surface:copyfrom(self.room, nil, {x=324, y = 0}, true)
	surface:copyfrom(self.backpack, nil, {x=2*width/3, y = height - 300}, true)

	-- Print the buttons
	self.button_grid:render(surface)

	-- Print the items
	for i = 1, #self.item_images do
		surface:copyfrom(self.item_images[i], nil, self.item_positions[i+1], true)
	end

	--Draw header
	self.header_font:draw(surface, {x=10,y=10}, "Your profile")

	-- Draw the profile picture
	surface:copyfrom(self.profile_picture, nil, {x = 524, y = height-330}, true)

	-- Draw profile info
	self.font:draw(surface, {x=10,y=70}, "Name: ")
	self.font:draw(surface, {x=180, y = 70}, self.profile:get_name())
	self.font:draw(surface, {x=10,y=105}, "Birthday: ")
	self.font:draw(surface, {x=180, y = 105}, tostring(self.profile:get_date_of_birth()))
	self.font:draw(surface, {x=10,y=140}, "Level: ")
	self.font:draw(surface, {x=180, y = 140}, tostring((self.profile:get_experience()-self.profile:get_experience()%100)/100))
	self.font:draw(surface, {x=10,y=175}, "Experience: ")
	self.font:draw(surface, {x=180, y = 175}, tostring(self.profile:get_experience()%100))

	--Draw Inventory header
	self.header_font:draw(surface, {x=10,y = 230}, "Inventory")

	-- Draw the info of the selected item
	local sel_index = self.button_grid:get_selected()
	if sel_index == 1 then

	else
		local item_selected = self.backpack_items[sel_index-1]
		self.font:draw(surface, {x = 10, y = 380}, "Item name: ")
		self.font:draw(surface, {x = 180, y = 380}, item_selected:get_name())
		self.font:draw(surface, {x=10, y = 415}, "Description: ")
		self.font:draw(surface, {x = 180, y = 415}, item_selected:get_description())
		self.font:draw(surface, {x=10, y = 450}, "Bought in: ")
		self.font:draw(surface, {x = 180, y = 450}, item_selected:get_city())
		self.font:draw(surface, {x=10, y = 485}, "Original price: ")
		self.font:draw(surface, {x = 180, y = 485}, self.profile:get_city().country:format_balance(item_selected:get_price()))
	end

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
