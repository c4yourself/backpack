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
	-- Add some internal variables that we will want to use later
	View.__init(self)
	self.background_path = ""
	self.current_city = city
	self.button_grid = ButtonGrid(remote_control)
	self.cashier = gfx.loadpng("data/images/cashier1.png")
	self.shelf = gfx.loadpng("data/images/shelf.png")
	self.backpack = gfx.loadpng("data/images/backpack.png")
	self.backendstore = BackEndStore()
	self.profile = profile
	self.remote_control = remote_control

	-- Some colors
	self.background_color = Color{255, 255, 204, 255}
	self.button_active = Color{255, 51, 51, 255}
	self.button_inactive = Color{255, 153, 153, 255}

	-- Creates local variables for height and width
	local height = screen:get_height()
	local width = screen:get_width()

	-- Get the items relevant for the current city
	self.items = self.backendstore:returnItemList(self.current_city)

	-- Get the profiles backpack items
	self.backpack_items = self.backendstore:returnBackPackItems(self.profile:get_inventory())

	-- Create the number of buttons that correspond to items in backpack + items for sale
	self.button_size = {width = 3.5*width/45, height = 3.5*width/45}
	self.buttons = {}
	self.buttons[1] = Button(self.button_inactive, self.button_active, self.button_inactive, true, true)
	k = 2
	while k <= get_size(self.items) + get_size(self.backpack_items) do
			self.buttons[k] = Button(self.button_inactive, self.button_active, self.button_inactive, true, false)
			k = k + 1
	end

	-- Add the exit button
	exit_font = Font("data/fonts/DroidSans.ttf", 24, Color(255, 0, 0, 255))
	self.buttons[k] = Button(self.button_inactive, self.button_active, self.button_inactive, true, false)
	self.buttons[k]:set_textdata("Exit",Color(255,0,0,255), {x = 100, y = 300}, 20, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Add them to button grid at the correct place
	row = 1
	j = 1
	own_items = 0
	while j <= get_size(self.items) + get_size(self.backpack_items) do
		self.button_grid:add_button({x = width/2+170+((j-1)-2*(row-1))*180+own_items*140,
																y = 115 + 140*(row-1-0.8*own_items) + own_items*175}, self.button_size, self.buttons[j])
		j = j + 1
		if (j-1) % 2 == 0 then
			row = row + 1
		end
		if j > get_size(self.items) then
			own_items = 1
		end
	end

	-- Add exit button
	self.button_grid:add_button({x = 200,y = 650}, {width = 6*width/45,height = 2*width/45}, self.buttons[k])

	-- Add to view
	self.add_view(self.button_grid, false)

	-- Some fix for movement
	self:listen_to(event.remote_control, "button_press", function() self:dirty() end)

end

function Store:insert_button()

	add_index = get_size(self.items) + get_size(self.backpack_items)
	print(add_index)

	local height = screen:get_height()
	local width = screen:get_width()
	print(height.. " " .. width)

	table.insert(self.buttons, add_index, Button(self.button_inactive, self.button_active, self.button_inactive, true, false))

	j = 1
	row = 1
	while j < add_index do
		j = j+1
		if (j-1)%2 == 0 then
			row = row + 1
		end
	end
	own_items = 1
	self.button_grid:insert_button({x = width/2+170+((add_index-1)-2*(row-1))*180+own_items*140,
															y = 115 + 140*(row-1-0.8*own_items) + own_items*175}, self.button_size, self.buttons[add_index],add_index)

end

function Store:render(surface)
	-- Creates local variables for height and width
	local height = screen:get_height()
	local width = screen:get_width()

	-- Resets the surface and draws the background
	surface:clear(self.background_color)
	surface:copyfrom(self.cashier, nil, {x = 0, y = 80}, true)
	surface:copyfrom(self.shelf, nil, {x=width/2,y=100}, true)
	surface:copyfrom(self.backpack, nil, {x=width/2+40, y = 450}, true)

	-- Print the buttons
	self.button_grid:render(surface)

	-- Instance remote control and mapps it to the buttons
	local callback = utils.partial(self.action_made, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		callback
	)

	self:dirty(false)

end

function Store:purchase_item(item_index)

	-- Some variables for ease
	local can_buy = false
	local balance = self.profile:get_balance()
	local item = self.items[item_index]
	local item_price = item:get_price()

	-- Start by checking if the user are allowed to purchase this item

	-- Check if the backpack has room
	if get_size(self.backpack_items) < 4 then

		-- If so, check if there's money
		if balance >= item_price then

				-- Purchase is allowed
				can_buy = true

		else

				can_buy = false

		end

	else

		can_buy = false

	end

	if can_buy then
		self.profile:modify_balance(-1*item_price)
		self.profile:add_item(item:get_id())
		self.backpack_items = self.backendstore:returnBackPackItems(self.profile:get_inventory())
		self:insert_button()
	end

end

function Store:sell_item(item)

end

function Store:action_made(button)

	-- If the player has presseed enter a choice has been made
	if button == "ok" then

		-- Get the current
		selected_index = self.button_grid:get_selected()
		print(selected_index)

		if selected_index <= get_size(self.items) then

			purchase = self:purchase_item(selected_index)

		elseif selected_index <= (get_size(self.items) + get_size(self.backpack_items)) then

			sell_off = sell_item(selected_index-get_size(self.items))

		else

			sys.stop()

		end

	end

end

-- Function that purchases the item

return Store
