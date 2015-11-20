--- ButtonGrid class.
-- This class handles the layout of buttons,
-- renders buttons on the current view, and
-- renders texts for each button.
-- Each view shall have its own ButtonGrid
-- @classmod ButtonGrid

local class = require("lib.classy")
local view = require("lib.view")
local View = require("lib.view.View")
local button = require("lib.components.Button")
local ButtonGrid = class("ButtonGrid",View)
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local event = require("lib.event")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
--local CityView = require("views.CityView")

--- Constructor for ButtonGrid
function ButtonGrid:__init(remote_control)
	View.__init(self)
	self.button_list = {} -- a list contains all buttons for the view.
	self.start_indicator = true -- will function just once, help to map the indicator with
															-- the selected button when the button grid is created.
	self.button_indicator = nil-- the indicator will point to the selected button when rendering occurs.

  if remote_control ~= nil then
    self.event_listener = remote_control
  else
    self.event_listener = event.remote_control
  end

  local callback = utils.partial(self.press, self)
  self:listen_to(
  self.event_listener,
  "button_press",
  callback
  )
	--
	-- local dirtycallback = function()
	-- 	self:dirty(false)
	-- 	self:dirty(true)
	-- end
  -- self:listen_to(
	--
  -- "dirty",
  -- dirtycallback
  -- )
end

--- Used when buttons need to be added to the view
-- @param position The button's position on the surface
-- @param button_size The size of button
-- @param button The button instance
-- @throws Error If the button cross the boundaries of the surface
function ButtonGrid:add_button(position, button_size, button)
-- chenck if the button across the screen boundaries
	if position.x >= 0 and button_size.width >= 0
		 and position.x + button_size.width < 1280
		 and position.y >= 0 and button_size.height >= 0
		 and position.y + button_size.height < 720	then
-- if ok, insert each button to the button_list
	 table.insert(self.button_list,
	 {button = button,
	 x = position.x,
	 y = position.y,
	 width = button_size.width,
	 height = button_size.height
	 })

else
	error("screen boundary error")
end

end

--- Display text for each button on the surface
-- @param button_index To indicate which button's text shall be displayed
function ButtonGrid:display_text(surface, area, button_index)
	local button_data = self.button_list[button_index].button

	local text_button = Font(
									button_data.font_path,
									button_data.font_size,
									button_data.font_color)

	text_button:draw(surface, {x = self.button_list[button_index].x, y = self.button_list[button_index].y,
														width = self.button_list[button_index].width, height = self.button_list[button_index].height}, button_data.text, "center", "middle")
end

function ButtonGrid:display_next_view(transfer_path)

 	local view_import = require(transfer_path)
 	local view_instance = view_import()

 	view.view_manager:set_view(view_instance)
end

function ButtonGrid:press(button)
	if not self.paused then
    if button == "down" then
			self:indicate_downward(self.button_indicator)
			self:trigger("dirty")
		elseif button == "up" then
			self:indicate_upward(self.button_indicator)
			self:trigger("dirty")
		elseif button == "right" then
			self:indicate_rightward(self.button_indicator)
			self:trigger("dirty")
		elseif button == "left" then
			self:indicate_leftward(self.button_indicator, "left")
			self:trigger("dirty")
		elseif button == "1" then
				--Instanciate a numerical quiz
				--local numerical_quiz_view = NumericalQuizView()
				--Stop listening to everything
				-- TODO
				-- Start listening to the exit event, which is called when the user
				-- exits a quiz

				--Update the view
				--numerical_quiz_view:render(screen)
				-- TODO This should be done by a subsurface in the final version
				--gfx.update()
		elseif button == "2" then
				multiplechoice_quiz.render(screen)
				gfx.update()
		elseif button == "3" then
				sys.stop()

		elseif button == "ok" then

			for i=1, #self.button_list do
				if self.button_list[i].button:is_selected() == true then
					if self.button_list[i].button.transfer_path ~= nil then
					self:display_next_view(self.button_list[i].button.transfer_path)
				--	gfx.update()
					break
					end
				end
	end
	end
end


	collectgarbage()  --ensure that memory-leak does not occur

end

--- Makes the ButtonGrid stop listening to input until unpaused
function ButtonGrid:pause()
	self.paused = true
end

--- Makes the ButtonGrid start listening to input until paused
function ButtonGrid:unpause()
	self.paused = false
end

--- Providing a subsurface to each button,
-- so the button can be rendered with its own render function.
-- If the button has text, then display the text as well
function ButtonGrid:render(surface)
-- If no button is selected when this button_grid is created,
-- then the first button in the list will be selected.
-- The indicator always points to the selected button
self:dirty(false)
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
			self:display_text(surface, area, i)
	   end
   end
end

--- When "down" is pressed, the indicator shall follow the down-direction
-- @param button_indicator The current indicator that points to the selected button
function ButtonGrid:indicate_downward(button_indicator)
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
function ButtonGrid:indicate_upward(button_indicator)
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

function ButtonGrid:indicate_rightward(button_indicator)
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

function ButtonGrid:indicate_leftward(button_indicator, direction)
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



function ButtonGrid:button_distance(sel_button_index, button_index)
	local sel_central_x = self.button_list[sel_button_index].x + math.floor(self.button_list[sel_button_index].width/2)
	local sel_central_y = self.button_list[sel_button_index].y + math.floor(self.button_list[sel_button_index].height/2)
	local central_x = self.button_list[button_index].x + math.floor(self.button_list[button_index].width/2)
	local central_y = self.button_list[button_index].y + math.floor(self.button_list[button_index].height/2)
	local distances = math.floor(math.sqrt(math.pow(central_x - sel_central_x, 2) + math.pow(central_y - sel_central_y, 2)))
	return distances
end

function ButtonGrid:distance_to_corner(corner_position, button_index)

	local central_x = self.button_list[button_index].x + math.floor(self.button_list[button_index].width/2)
	local central_y = self.button_list[button_index].y + math.floor(self.button_list[button_index].height/2)
	local corner_x = corner_position.x
	local corner_y = corner_position.y
	local distances = math.floor(math.sqrt(math.pow(central_x - corner_x, 2) + math.pow(central_y - corner_y, 2)))
	return distances
end

return ButtonGrid
