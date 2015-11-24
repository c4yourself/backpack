--- NumericalQuizGrid class.
-- @classmod NumericalQuizGrid

local class = require("lib.classy")
local button = require("lib.components.Button")
local ButtonGrid = require("lib.components.ButtonGrid")
local NumericalQuizGrid = class("NumericalQuizGrid", ButtonGrid)
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local event = require("lib.event")

--- Constructor for NumericalQuizGrid
function NumericalQuizGrid:__init(remote_control)
	ButtonGrid.__init(self, remote_control)
	self.num_input_comp = nil-- Reference the input component
	self.back_button = nil
	self.next_button = nil

	local callback = utils.partial(self.release, self)
	self:listen_to(
	self.event_listener,
	"button_release",
	callback
	)

end

function NumericalQuizGrid:mark_as_input_comp(index)
	self.num_input_comp = index
end

function NumericalQuizGrid:mark_as_next_button(index)
	self.next_button = index
end

function NumericalQuizGrid:mark_as_back_button(index)
	self.back_button = index
end

function NumericalQuizGrid:get_last_index()
	return #self.button_list
end

function NumericalQuizGrid:release(button)
	if button == "ok" then
		--Depending on which button was selected do different stuff
		if self.button_indicator == self.num_input_comp then
			self:trigger("submit")
		elseif self.button_indicator == self.back_button then
			self:trigger("back")
		elseif self.button_indicator == self.next_button then
			self:trigger("next")
		end
	end
end


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
		end
		print("indicator: " .. self.button_indicator)
		print("\n" .. "\n" .. "\n" .. "\n" .. "\n" .. "\n")
	--end
end

--- Makes sure to focus the input component if the user has moved the indicator
-- to it
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

--- Providing a subsurface to each button,
-- so the button can be rendered with its own render function.
-- If the button has text, then display the text as well
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
				self:display_text(surface, area, i)
	   		end
		else
			button_data.button:render(sub_surface)
		end
   end
   gfx.update()
end

return NumericalQuizGrid
