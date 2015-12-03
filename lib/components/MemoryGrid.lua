--- MemoryGrid class. This class builds on the ButtonGrid class and represents
-- a set of memory cards and buttons in the MemoryView. Memory cards are
-- represented by the @{CardComponent} class
-- @classmod MemoryGrid

local class = require("lib.classy")
local button = require("lib.components.Button")
local ButtonGrid = require("lib.components.ButtonGrid")
local MemoryGrid = class("MemoryGrid", ButtonGrid)
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local event = require("lib.event")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local view = require("lib.view")
local logger = require("lib.logger")

--- Constructor for MemoryGrid.
-- @param remote_control Remote control or remote control mock to listen to.
function MemoryGrid:__init(remote_control)
	ButtonGrid.__init(self, remote_control)
	self.temp_turned = {}
	self.turned = {}
	self.last_selection = 0
end

--- Used when buttons/cards need to be added to the view
-- @param position The button's/card's position on the surface
-- @param button_size The size of button/card
-- @param button The button/card instance
-- @throws Error If the button/card cross the boundaries of the surface
function MemoryGrid:add_button(position, button_size, button)
	if position.x >= 0 and button_size.width >= 0
		 and position.x + button_size.width < 1280
		 and position.y >= 0 and button_size.height >= 0
		 and position.y + button_size.height < 720	then
	-- if ok, insert button to the button_list
		self:add_view(button)
		table.insert(self.button_list,
			{button = button,
			x = position.x,
			y = position.y,
	 		width = button_size.width,
	 		height = button_size.height
	 		})
		local button_callback = utils.partial(self.trigger, self, "dirty")
	 	self:listen_to(
	 		button,
			"dirty",
			button_callback
	 	)
	else
		error("screen boundary error")
	end
end


--- Display text for each button/card on the surface
-- @param button_index To indicate which button's text shall be displayed
function MemoryGrid:display_text(surface, button_index)
		local button_data = self.button_list[button_index].button
		local text_button = Font(
										button_data.font_path,
										button_data.font_size,
										button_data.font_color)

		text_button:draw(surface, {x = self.button_list[button_index].x,
						y = self.button_list[button_index].y,
						width = self.button_list[button_index].width,
						height = self.button_list[button_index].height},
						button_data.text, "center", "middle")
	end

--- When "down" is pressed, the indicator shall follow the down-direction
-- @param button_indicator The current indicator that points to the selected button
function MemoryGrid:indicate_downward(button_indicator)
	local indicator = button_indicator
	local button_list = self.button_list
	local shortest_distance_buttons = 720
	local shortest_distance_corner = 720
	local sel_central_x = button_list[indicator].x + math.floor(button_list[indicator].width/2)
	local sel_central_y = button_list[indicator].y + math.floor(button_list[indicator].height/2)
	local nearest_button_index = nil
	local corner_position = {x = math.min(button_list[indicator].x), y = 0}

	local that_distance = self:distance_to_corner(corner_position, 2)

	for i=1, #button_list do
		if button_list[i].y >= button_list[indicator].y + button_list[indicator].height then
			local distance = self:button_distance(indicator, i)
			shortest_distance_buttons = math.min(shortest_distance_buttons, distance)
		end
	end

	if shortest_distance_buttons ~= 720 then
		for j=1, #button_list do
			if  button_list[j].y >= button_list[indicator].y + button_list[indicator].height then
				local distance = self:button_distance(indicator, j)
				if shortest_distance_buttons == distance then
					nearest_button_index = j
					break
				end
			end
	 	end
	end

	if shortest_distance_buttons == 720 and #button_list ~= 1 then
		for k=1, #button_list do
				local distance = self:distance_to_corner(corner_position, k)
				shortest_distance_corner = math.min(shortest_distance_corner, distance)
				--print("the minium distance at the moment is "..shortest_distance_corner)
		end
	end

	if shortest_distance_corner ~= 720 then
	for p=1, #button_list do
			local distances = self:distance_to_corner(corner_position, p)
			if shortest_distance_corner == distances then
				nearest_button_index = p
				break
			end
		end
	end

	if nearest_button_index ~= nil then
		indicator = nearest_button_index
		button_list[indicator].button:select(true)
		button_list[button_indicator].button:select(false)
	end

	self.button_indicator = indicator
end

--- When "up" is pressed, the indicator shall follow the up-direction
-- @param button_indicator The current indicator that points to the selected button
function MemoryGrid:indicate_upward(button_indicator)
	local indicator = button_indicator
	local button_list = self.button_list
	local shortest_distance_buttons = 720
	local shortest_distance_corner = 720
	local sel_central_x = button_list[indicator].x + math.floor(button_list[indicator].width/2)
	local sel_central_y = button_list[indicator].y + math.floor(button_list[indicator].height/2)
	local nearest_button_index = nil
	local corner_position = {x = button_list[indicator].x, y = 720}

	for i=1, #button_list do
		if button_list[i].y + button_list[i].height <= button_list[indicator].y then
			local distance = self:button_distance(indicator, i)
			shortest_distance_buttons = math.min(shortest_distance_buttons, distance)
		end
	end

	if shortest_distance_buttons ~= 720 then
		for j=1, #button_list do
			if button_list[j].y + button_list[j].height <= button_list[indicator].y then
				local distance = self:button_distance(indicator, j)
				if shortest_distance_buttons == distance then
					-- print("the distance is "..distance)
					nearest_button_index = j
					break
				end
			end
		end
	end

	if shortest_distance_buttons == 720 and #button_list ~= 1 then
		for k=1, #button_list do
				local distance = self:distance_to_corner(corner_position, k)
				shortest_distance_corner = math.min(shortest_distance_corner, distance)
		end
	end

	if shortest_distance_corner ~= 720 then
	for p=1, #button_list do
			local distance = self:distance_to_corner(corner_position, p)
			if shortest_distance_corner == distance then
				nearest_button_index = p

				break
			end
		end
	end

	if nearest_button_index ~= nil then
		indicator = nearest_button_index
		button_list[indicator].button:select(true)
		button_list[button_indicator].button:select(false)
	end

	self.button_indicator = indicator
end

--- When "right" is pressed, the indicator shall follow the rightward direction
-- @param button_indicator The current indicator that points to the selected button
function MemoryGrid:indicate_rightward(button_indicator)
	local indicator = button_indicator
	local button_list = self.button_list
	local shortest_distance_buttons = 1280
	local shortest_distance_corner = 1280
	local sel_central_x = button_list[indicator].x + math.floor(button_list[indicator].width/2)
	local sel_central_y = button_list[indicator].y + math.floor(button_list[indicator].height/2)
	local nearest_button_index = nil
	local corner_position = {x = 0, y = button_list[indicator].y}

	for i=1, #button_list do
		if button_list[i].x >= button_list[indicator].x + button_list[indicator].width then
			local distance = self:button_distance(indicator, i)
			shortest_distance_buttons = math.min(shortest_distance_buttons, distance)
		end
	end

	if shortest_distance_buttons ~= 1280 then
		for j=1, #button_list do
			if button_list[j].x >= button_list[indicator].x + button_list[indicator].width then
				local distance = self:button_distance(indicator, j)
				if shortest_distance_buttons == distance then
					nearest_button_index = j
					break
				end
			end
	 	end
	end

	if shortest_distance_buttons == 1280 and #button_list ~= 1 then
		for k=1, #button_list do
				local distance = self:distance_to_corner(corner_position, k)
				shortest_distance_corner = math.min(shortest_distance_corner, distance)
		end
	end

	if shortest_distance_corner ~= 1280 then
	for p=1, #button_list do
			local distance = self:distance_to_corner(corner_position, p)
			if shortest_distance_corner == distance then
				nearest_button_index = p
				break
			end
		end
	end

	if nearest_button_index ~= nil then
		indicator = nearest_button_index
		button_list[indicator].button:select(true)
		button_list[button_indicator].button:select(false)
	end

	self.button_indicator = indicator
end


--- When "left" is pressed, the indicator shall follow the leftward direction
-- @param button_indicator The current indicator that points to the selected button
function MemoryGrid:indicate_leftward(button_indicator, direction)
	local indicator = button_indicator
	local button_list = self.button_list
	local shortest_distance_buttons = 1280
	local shortest_distance_corner = 1280
	local sel_central_x = button_list[indicator].x + math.floor(button_list[indicator].width/2)
	local sel_central_y = button_list[indicator].y + math.floor(button_list[indicator].height/2)
	local nearest_button_index = nil
	local corner_position = {x = 1280, y = button_list[indicator].y}
	local condition = nil

	for i=1, #button_list do
		if button_list[indicator].x >= button_list[i].x + button_list[i].width then
			local distance = self:button_distance(indicator, i)
			shortest_distance_buttons = math.min(shortest_distance_buttons, distance)
		end
	end

	if shortest_distance_buttons ~= 1280 then
		for j=1, #button_list do
			if  button_list[indicator].x >= button_list[j].x + button_list[j].width then
				local distance = self:button_distance(indicator, j)
				if shortest_distance_buttons == distance then
					--print("the distance is "..distance)
					nearest_button_index = j
					--print("the nearast button is ".. nearest_button_index)
					break
				end
			end
		end
	end

	if shortest_distance_buttons == 1280 and #button_list ~= 1 then
		for k=1, #button_list do
				local distance = self:distance_to_corner(corner_position, k)
				shortest_distance_corner = math.min(shortest_distance_corner, distance)
		end
	end

	if shortest_distance_corner ~= 1280 then
	for p=1, #button_list do
			local distance = self:distance_to_corner(corner_position, p)
			if shortest_distance_corner == distance then
				nearest_button_index = p
				break
			end
		end
	end

	if nearest_button_index ~= nil then
		indicator = nearest_button_index
		button_list[indicator].button:select(true)
		button_list[button_indicator].button:select(false)
	end

	self.button_indicator = indicator
end

---Calculates the distance between the two buttons or cards specified
--@param sel_button_index Number representing the index of button one
--@param button_index Number representing the index of button two
function MemoryGrid:button_distance(sel_button_index, button_index)
	local sel_central_x = self.button_list[sel_button_index].x + math.floor(self.button_list[sel_button_index].width/2)
	local sel_central_y = self.button_list[sel_button_index].y + math.floor(self.button_list[sel_button_index].height/2)
	local central_x = self.button_list[button_index].x + math.floor(self.button_list[button_index].width/2)
	local central_y = self.button_list[button_index].y + math.floor(self.button_list[button_index].height/2)
	local distances = math.floor(math.sqrt(math.pow(central_x - sel_central_x, 2) + math.pow(central_y - sel_central_y, 2)))
	return distances
end

---Calculates the distance between the the corner of one button or card to
-- another button or card
--@param corner_position table with x and y fields representing x and y position
--@param button_index Number representing the index of button/card to measure
-- 		distance to
function MemoryGrid:distance_to_corner(corner_position, button_index)

	local central_x = self.button_list[button_index].x + math.floor(self.button_list[button_index].width/2)
	local central_y = self.button_list[button_index].y + math.floor(self.button_list[button_index].height/2)
	local corner_x = corner_position.x
	local corner_y = corner_position.y
	local distances = math.floor(math.sqrt(math.pow(central_x - corner_x, 2) + math.pow(central_y - corner_y, 2)))
	return distances
end

--- Overloaded press function. Responds to a user button press and determines a
-- new state for the quiz.
--@param button Button that the user pressed
function MemoryGrid:press(button)
	if button == "down" then
		logger.debug(string.format("i press"))
		self:indicate_downward(self.button_indicator)
		self:dirty(true)
		self:trigger("navigation")
	elseif button == "up" then
		self:indicate_upward(self.button_indicator)
		self:dirty(true)
		self:trigger("navigation")
	elseif button == "right" then
		self:indicate_rightward(self.button_indicator)
		self:dirty(true)
		self:trigger("navigation")
	elseif button == "left" then
		self:indicate_leftward(self.button_indicator, "left")
		self:dirty(true)
		self:trigger("navigation")
	end

	if button == "ok" then
		self.last_selection = self.button_indicator
		self:trigger("submit")
	end
end

---Renders the MemoryGrid and all its child components, given that they are
-- flagged as dirty, on the specified Surface
--@param surface @{Surface} or @{SubSurface} to render on
function MemoryGrid:render(surface)
-- If no button is selected when this button_grid is created,
-- then the first button in the list will be selected.
-- The indicator always points to the selected button
	self:dirty(false)
	self.render_surface = surface
	if self.start_indicator == true then
		for k = 1 , #self.button_list do
			if self.button_list[k].button:is_selected() then
				self.button_indicator = k
			end
		end

		if self.button_indicator == nil then
			self.button_indicator = 1
			self.button_list[1].button:select(true)
		end

		self.start_indicator = false
  end


-- Go through the button_list to render all buttons
	for i=1 , #self.button_list do
		local button_data = self.button_list[i]
		local area = {
			width = button_data.width,
			height	=button_data.height,
			x = button_data.x,
			y = button_data.y
		}

		local sub_surface = SubSurface(surface,area)

			button_data.button:render(sub_surface)
			if button_data.button.text_available then
				self:display_text(surface, i)
			end
   		end
   gfx.update()
end

--- Sets the card status for card with index i to be either facing up or facing
-- down. Triggers dirty if the status has changed. 
--@param status String representing the new status. May be one of the following
-- 				constants: "FACING_UP", "FACING_DOWN".
function MemoryGrid:set_card_status(card_index, status)
	self.button_list[card_index].button:set_card_status(status)
end

--- Sets status of several cards at once without triggering dirty between each
-- new status. Should be used instead of set_card_status when several statuses
-- needs to be changed at one time. Triggers dirty once complete.
--
--@param state_map Table with boolean values representing card states. If index
--					i in the stame map is true the card with index i will be
--					given the status "FACING_UP". Otherwise the card will be
--					given the status "FACING_DOWN".
function MemoryGrid:set_multiple_status(state_map)
	for i=1, #state_map do
		local state = state_map[i]
		if state == true then
			self.button_list[i].button.status = "FACING_UP"
		else
			self.button_list[i].button.status = "FACING_DOWN"
		end
	end
	self:trigger("dirty")
end

return MemoryGrid
