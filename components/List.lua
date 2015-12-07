--- Base class for List
-- The list is used in TravelView to display the available destinations
-- @classmod List

local class = require("lib.classy")
local View = require("lib.view.View")
local SubSurface = require("lib.view.SubSurface")
local event = require("lib.event")
local utils = require("lib.utils")

local List = class("List", View)

--- Standard initialiser
function List:__init(visible_items)
	View.__init(self)

	self.visible_items = visible_items or 3

	self.item_list = {} -- a list contains all ListItems for the view.

	self:listen_to(event.remote_control, "button_press", utils.partial(self.button_press, self))

	self.current_index = 1

	self.start_index = 1 -- list_item in top of of the visual list

end

--- Function to check the pressed key
-- @param key Is the key that has been pressed
function List:button_press(key)

	-- Move upward...
	if key == "up" then

		-- If we have marked the exit button
		if self.current_index == 0 then
			self.current_index = #self.item_list
			self.start_index = self.current_index - (self.visible_items - 1)
			self:trigger("unselect_back")

		-- Otherwise if we're at the top of the list we mark exit
		elseif self.current_index - 1 < 1 then
			self.current_index = 0
			self:trigger("select_back")

		-- Normal move upwards
		else
			self.current_index = self.current_index -1
			self:trigger("unselect_back")
		end

		self:dirty()

	-- Move downward...
	elseif key == "down" then

		-- If we're currently on exit button
		if self.current_index == 0 then
			self.current_index = 1
			self.start_index = 1
			self:trigger("unselect_back")

		-- If we're moving down from the last item..
		elseif self.current_index + 1 > #self.item_list then
			self.current_index = 0
			self:trigger("select_back")

		-- If normal downward move
		else
			self.current_index = self.current_index +1
			if self.current_index > self.visible_items then
				self.start_index = self.current_index - (self.visible_items - 1)
			end
			self:trigger("unselect_back")
		end

		self:dirty()
	end

end

--- Function to add list_item to List (last)
-- @param list_item is the item to be added
function List:add_list_item(list_item)
	 table.insert(self.item_list, list_item)
end

--- Function that return the currently selected index (and maximum index)
function List:return_curr_index()
	return self.current_index, #self.item_list
end

--- Standard render function
function List:render(surface)

	surface:clear({65, 70, 72, 255})
	surface:clear({255, 255, 255, 255},
	{x = 5, y = 5, width = surface:get_width() - 10, height = surface:get_height() - 10})

	local height = math.floor(
		(surface:get_height() - 12 - self.visible_items) / self.visible_items)

	local end_index = self.start_index + self.visible_items - 1
	for i = self.start_index , end_index do

		local list_data = self.item_list[i]

		if i == self.current_index then
			list_data:select(true)
		else
			list_data:select(false)
		end

		local current_height = height
		if i == end_index then
			current_height = surface:get_height() - 12 - (self.visible_items - 1) * (height + 1)
		end

		local sub_surface = SubSurface(surface, {
			x = 6,
			y = 6 + (i - self.start_index) * (height + 1),
			width = surface:get_width() - 12,
			height = current_height
		})
		list_data:render(sub_surface)
  end
	self:dirty(false)
end


return List
