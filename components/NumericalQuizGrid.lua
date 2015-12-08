--- NumericalQuizGrid class. Handles the buttons and the input field for the
-- @{NumericalQuizView} class.
-- @classmod NumericalQuizGrid

local class = require("lib.classy")
local ButtonGrid = require("components.ButtonGrid")
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local event = require("lib.event")

local NumericalQuizGrid = class("NumericalQuizGrid", ButtonGrid)

--- Constructor for NumericalQuizGrid
--@param remote_control Remote control or mock to listen to. Defaults to the
--						global remote_control object.
function NumericalQuizGrid:__init(remote_control)
	ButtonGrid.__init(self, remote_control)
	self.num_input_comp = nil-- Reference the input component
	self.back_button = nil
	self.next_button = nil
end

--- Selects the next button and deselects all other buttons.
function NumericalQuizGrid:select_next()
	for i = 1, #self.button_list do
		self.button_list[i].button._selected = false
	end
	self.button_list[self.next_button].button._selected = true
	self.button_indicator = self.next_button
end

--- Method for manually selecting a button in the grid.
-- @param index Integer specifying the button to be selected. The index should
--				be key to the button in the grid's button_list.
function NumericalQuizGrid:select_button(index)
	for i = 1, #self.button_list do
		self.button_list[i].button._selected = false
	end
	self.button_list[index].button._selected = true
	self.button_indicator = index
end

--- Marks the object with the specified index as the input component. This
-- enables the grid to differentiate between the input field and the other buttons
--@param index Integer specifying which component in the grid's button_list that
--				should be marked as the input field
function NumericalQuizGrid:mark_as_input_comp(index)
	self.num_input_comp = index
end

--- Marks the object with the specified index as the quiz's next button.
-- Enables the grid to differentiate between the next button and the other buttons
--@param index Integer specifying which component in the grid's button_list that
--				should be marked as the next button
function NumericalQuizGrid:mark_as_next_button(index)
	self.next_button = index
end

--- Marks the object with the specified index as the quiz's back button.
-- Enables the grid to differentiate between the back button and the other buttons
--@param index Integer specifying which component in the grid's button_list that
--				should be marked as the back button
function NumericalQuizGrid:mark_as_back_button(index)
	self.back_button = index
end

---Fetches the index of the last object added to the grid
function NumericalQuizGrid:get_last_index()
	return #self.button_list
end

---Determines what event should be triggered based on user input.
--@param button Button that the user pressed
function NumericalQuizGrid:press(button)
	--if not self.paused then
    	if button == "down" then
			self:indicate_downward(self.button_indicator)
			self:_check_for_input_component(self.button_indicator)
			self:trigger("dirty")
		elseif button == "up" then
			self:indicate_upward(self.button_indicator)
			self:_check_for_input_component(self.button_indicator)
			self:trigger("dirty")
		elseif button == "right" then
			self:indicate_rightward(self.button_indicator)
			self:_check_for_input_component(self.button_indicator)
			self:trigger("dirty")
		elseif button == "left" then
			self:indicate_leftward(self.button_indicator, "left")
			self:_check_for_input_component(self.button_indicator)
			self:trigger("dirty")
		elseif button == "ok" then
			if self.button_indicator == self.num_input_comp then
				self:trigger("submit")
			elseif self.button_indicator == self.back_button then
				self:trigger("back")
			elseif self.button_indicator == self.next_button then
				self:trigger("next")
			end
		end
	--end
end

--- Checks if the component with the specified index is the input field. If
-- that's the case the field will be focused. If not the field will be blurred.
-- Used for making sure the input field is focused when the user moves the
-- indicator to it.
--
-- @param index Integer specifying which component to check
function NumericalQuizGrid:_check_for_input_component(index)
	if index == self.num_input_comp then
		if not self.num_input_comp == nil then
			self.num_input_comp:focus()
		end
		return true
	end
	if not self.num_input_comp == nil then
		self.num_input_comp:blur()
	end
	return false
end

--- Provides a subsurface to each button,
-- so the button can be rendered with its own render function.
-- If the button has text, then display the text as well
-- @param surface @{Surface} or @{SubSurface} to render the grid on.
function NumericalQuizGrid:render(surface)
-- If no button is selected when this button_grid is created,
-- then the first button in the list will be selected.
-- The indicator always points to the selected button
	if self.start_indicator == true then
		for k = 1 , #self.button_list do
			if not (self:_check_for_input_component(k)
			or self.num_input_comp == nil) then
				if self.button_list[k].button:is_selected() then
					self.button_indicator = k
				end
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
			height = button_data.height,
			x = button_data.x,
			y = button_data.y
		}

		local sub_surface = SubSurface(surface,area)
		if not self:_check_for_input_component(i) then
				button_data.button:render(sub_surface)
      		if button_data.button.text_available then
				self:display_text(surface, i)
	   		end
		else
			button_data.button:render(sub_surface)
		end
   end
   gfx.update()
end

return NumericalQuizGrid
