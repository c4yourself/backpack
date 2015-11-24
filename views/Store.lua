-- The view class store
-- @classmod Store
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
-- @param a Is the table to get ther size of
local function get_size(a)
	i = 0
	for _ in pairs(a) do i = i+1 end
	return i
end

--- Constructor for Store
-- @param event_listener Remote control to listen to
function Store:__init(remote_control, surface, profile)
	-- Add some internal variables that we will want to use later
	View.__init(self)
	self.surface = surface
	self.background_path = ""
	self.current_city = profile:get_city().name
	self.button_grid = ButtonGrid(remote_control)
	self.cashier = gfx.loadpng("data/images/cashier.png")
	self.shelf = gfx.loadpng("data/images/shelf.png")
	self.backpack = gfx.loadpng("data/images/backpack.png")
	self.backendstore = BackEndStore()
	self.profile = profile
	self.remote_control = remote_control
	self.item_positions = {}
	self.item_images = {}
	self.message = {["message"] = "Select item to purchase or sell"}


	-- Some colors
	self.background_color = Color{255, 255, 204, 255}
	self.button_active = Color{255, 51, 51, 255}
	self.button_inactive = Color{255, 153, 153, 255}

	-- Creates local variables for height and width
	local height = self.surface:get_height()
	local width = self.surface:get_width()

	-- Get the items relevant for the current city
	self.items = self.backendstore:returnItemList(self.current_city)
	print(#self.items)
	print(profile:get_city().name)

	-- Get the profiles backpack items
	self.backpack_items = self.backendstore:returnBackPackItems(self.profile:get_inventory())

	-- Create the number of buttons that correspond to items in backpack + items for sale
	self.button_size = {width = 2.5*width/45, height = 2.5*width/45}

	self.buttons = {}
	self.buttons[1] = Button(self.background_color, self.button_active, self.background_color, true, true)
	k = 2
	while k <= get_size(self.items) + get_size(self.backpack_items) do
			self.buttons[k] = Button(self.background_color, self.button_active, self.background_color, true, false)
			k = k + 1
	end

	-- Add the exit button
	self.font = Font("data/fonts/DroidSans.ttf", 20, Color(0, 0, 0, 255))
	self.header_font = Font("data/fonts/DroidSans.ttf", 40, Color(0,0,0,255))
	self.buttons[k] = Button(self.button_inactive, self.button_active, self.button_inactive, true, false)
	self.buttons[k]:set_textdata("Exit",Color(255,0,0,255), {x = 100, y = 300}, 20, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Add them to button grid at the correct place
	row = 1
	j = 1
	own_items = 0
	while j <= get_size(self.items) + get_size(self.backpack_items) do
		self.item_positions[j] = {x = width/2-100+((j-1)-2*(row-1))*130+own_items*185,
																y = 30 + 105*(row-1-0.8*own_items) + own_items*205}
		self.button_grid:add_button(self.item_positions[j], self.button_size, self.buttons[j])
		j = j+1
		if (j-1) % 2 == 0 then
			row = row + 1
		end
		if j > get_size(self.items) then
			own_items = 1
		end
	end

	-- Create list of item images
	self.item_images = self:loadItemImages()

	-- Add exit button
	self.button_grid:add_button({x = 720,y = 650}, {width = 6*width/45,height = 2*width/45}, self.buttons[k])

	-- Add to view
	self.add_view(self.button_grid, false)

	-- Some fix for movement
	--self:listen_to(event.remote_control, "button_release", function() self:dirty() end)
	local button_render = function()
		self:render(self.surface)
		gfx.update()
	end

	self:listen_to(
		self.button_grid,
		"dirty",
		button_render
	)

	-- Instance remote control and mapps it to pressing enter
	self.callback = utils.partial(self.action_made, self)
	self:listen_to(event.remote_control,"button_release",self.callback)


end

-- Load all the images for the items
-- @param none
function Store:loadItemImages()
	local ret_list = {}
	local numItems =  get_size(self.items)
	for i = 1, numItems do
		ret_list[i] = gfx.loadpng(self.items[i]:get_image_path())
	end

	for j = 1, get_size(self.backpack_items) do
		ret_list[j+numItems] = gfx.loadpng(self.backpack_items[j]:get_image_path())
	end
	return ret_list
end


-- Function to insert a new item on the correct place
-- @param no needed
function Store:insert_button()
	-- Where to add
	add_index = get_size(self.items) + get_size(self.backpack_items)

	-- Some sizes for positioning
	local height = self.surface:get_height()
	local width = self.surface:get_width()

	-- Add to table of buttons
	table.insert(self.buttons, add_index, Button(self.background_color, self.button_active, self.background_color, true, false))

	-- Calculations of where to draw the button
	j = 1
	row = 1
	while j < add_index do
		j = j+1
		if (j-1)%2 == 0 then
			row = row + 1
		end
	end
	own_items = 1
	table.insert(self.item_positions, add_index, {x = width/2-100+((add_index-1)-2*(row-1))*130+own_items*185,
															y = 30 + 105*(row-1-0.8*own_items) + own_items*205})
	-- Add to button grid
	self.button_grid:insert_button(self.item_positions[add_index], self.button_size, self.buttons[add_index],add_index)

end

-- Function to remove a button, as an item has been sold
-- @param item_index to know item is actually removed
function Store:remove_button(index)

	-- Get the index of the button to be removed
	remove_index = get_size(self.items) + get_size(self.backpack_items) + 1
	-- Remove it from the button table
	table.remove(self.buttons, remove_index)
	-- Remove it from the images to be drawn
	table.remove(self.item_positions, remove_index)
	-- Remove the picture
	table.remove(self.item_images, index)
	-- Remove it from the button_grid
	self.button_grid:remove_button(remove_index, index)
end

-- Render view function
-- @param surface is the surface to draw on
function Store:render(surface)


	-- Creates local variables for height and width
	local height = self.surface:get_height()
	local width = self.surface:get_width()

		-- Resets the surface and draws the background
	surface:clear(self.background_color)
	surface:copyfrom(self.cashier, nil, {x = 0, y = 100}, true)
	surface:copyfrom(self.shelf, nil, {x=width/2-250,y=20}, true)
	surface:copyfrom(self.backpack, nil, {x=width/2-100, y = 350}, true)

	-- Print the buttons
	self.button_grid:render(surface)

	-- Print the items
	for i = 1, #self.item_images do
		surface:copyfrom(self.item_images[i], nil, self.item_positions[i], true)
	end

	-- Draw balacne
	local coins = self.profile:get_balance()
	self.font:draw(surface, {x = 2.9*width/4, y = height/8},"Coins: "..coins)

	--Draw item info is one is selected, exit info otherwise
	local selected_item_index = self.button_grid:get_selected()
	local exit_selected = false
	local item

	-- Find which is selected
	if selected_item_index <= get_size(self.items) then
		item = self.items[selected_item_index]
	elseif selected_item_index <= get_size(self.items) + get_size(self.backpack_items) then
		item = self.backpack_items[selected_item_index - get_size(self.items)]
	else
		exit_selected = true
	end

	-- See what we're doing
	if exit_selected then
		self.font:draw(surface, {x = 2.9*width/4, y = height/8+45}, "Exit the store")
	else
		self.font:draw(surface, {x = 2.9*width/4, y = height/8+45}, "Item: " .. item:get_name())
		self.font:draw(surface, {x = 2.9*width/4, y = height/8+70}, "Description: "..item:get_description())
		if selected_item_index <= get_size(self.items) then
			self.font:draw(surface, {x = 2.9*width/4, y = height/8+95}, "Purchase price: " .. item:get_price())
		else
			self.font:draw(surface, {x = 2.9*width/4, y = height/8+95},
			"Sale price: "..self.backendstore:returnOfferPrice(item, self.current_city))
		end
	end
	print("i shoppen")
	self.font:draw(surface, {x = 2.9*width/4, y = height/8+130}, self.message["message"])
	--Draw header
	self.header_font:draw(surface, {x=10,y=10}, "Store")

end



-- Function that handles the purchase of an item with
-- checks if the item is allowed to be purchased
-- @param item_index is the index of the item to be purchased
function Store:purchase_item(item_index)

	-- Some variables for ease
	local can_buy = false
	local balance = self.profile:get_balance()
	local item = self.items[item_index]
	local item_price = item:get_price()
	local error_msg

	-- Start by checking if the user are allowed to purchase this item

	-- Check if the backpack has room
	if get_size(self.backpack_items) < 4 then

		-- If so, check if there's money
		if balance >= item_price then

				-- Purchase is allowed
				can_buy = true

		else

				can_buy = false
				error_msg = "Not enough coins"

		end

	else

		can_buy = false
		error_msg = "No room in backpack"

	end

	-- If we are allowed to purchase then...
	if can_buy then
		-- Change the balance of the profile
		self.profile:modify_balance(-1*item_price)
		-- Add the item to the profiles inventory
		self.profile:add_item(item:get_id())
		-- Get the new list of items
		self.backpack_items = self.backendstore:returnBackPackItems(self.profile:get_inventory())
		-- Insert a new button
		self:insert_button()

		self:dirty(false)

		return "Item purchased"
	end

	return error_msg

end

-- Function that handles the sale of an item
-- @param item_index is the index item that has been sold
function Store:sell_item(item_index)

	-- Local variables; which is sold and the price it's sold for
	local item = self.backpack_items[item_index]
	local sale_price = self.backendstore:returnOfferPrice(item, self.current_city)
	-- Add the sale price to the profiles balance
	self.profile:modify_balance(sale_price)
	-- Remove the item from the profile's backpack
	self.profile:remove_item(item:get_id())
	-- Get the new list of backpack items
	self.backpack_items = self.backendstore:returnBackPackItems(self.profile:get_inventory())
	-- Remove a button
	self:remove_button(item_index+get_size(self.items))

	self:dirty(false)

	return "Item sold"
end

-- The function that decides what happends when the "ok" button is pressed
-- @param button The button that has been pressed
function Store:action_made(button)

	-- If the player has presseed enter a choice has been made
	if button == "ok" then
		--
		-- -- Get the current index of button that is selected
		-- selected_index = self.button_grid:get_selected()
		--
		-- -- If we have selected on of the purchasable items
		-- if selected_index <= get_size(self.items) then
		--
		-- 	self.message["message"] = self:purchase_item(selected_index)
		--
		-- -- Elseif we have sold one of our items
		-- elseif selected_index <= (get_size(self.items) + get_size(self.backpack_items)) then
		--
		-- 	self.message["message"] = self:sell_item(selected_index-get_size(self.items))
		-- end
		-- Otherwise we've exited
	elseif button =="back" then

		self:trigger("exit_view")
			--self:destroy()
			--sys.stop()



	end

	-- Reload the relevant images after an action is made
	self.item_images = self:loadItemImages()


end

-- Function to destory images
function Store:destroy()
  view.View.destroy(self)
  for k,v in pairs(self.item_images) do
     self.item_images[k]:destroy()
  end
	self.cashier:destroy()
	self.shelf:destroy()
	self.backpack:destroy()
end

return Store
