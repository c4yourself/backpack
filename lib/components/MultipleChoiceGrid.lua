--- MultipleChoiceGrid class.
-- This class builds on the ButtonGrid class and is used for buttons in the
-- multiple choice quiz
-- @classmod ButtonGrid

local class = require("lib.classy")
local button = require("lib.components.Button")
local NumericalQuizGrid = require("lib.components.NumericalQuizGrid")
local MultipleChoiceGrid = class("MultipleChoiceGrid", NumericalQuizGrid)
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local event = require("lib.event")

--- Constructor for NumericalQuizGrid
function MultipleChoiceGrid:__init(remote_control)
	NumericalQuizGrid.__init(self,remote_control)
	self.input = {}
end

function MultipleChoiceGrid:toggle(button_indicator)
	if self.button_list[button_indicator].toggled == true then
		self.button_list[button_indicator].button:toggle()
		self.input[button_indicator-3] = button_indicator - 3
	else
		print("Button is now toggled")
		self.button_list[button_indicator].button:toggle()
		self.input[button_indicator-3] = nil
	end
end

function MultipleChoiceGrid:release(button)
	if button == "ok" then
		--Depending on which button was selected do different stuff
		if self.button_indicator == self.num_input_comp then
			self:trigger("submit")
		elseif self.button_indicator == self.back_button then
			self:trigger("back")
		elseif self.button_indicator == self.next_button then
			self:trigger("next")
		else
			print("TOGGLING!!!!!!!")
			self:toggle(self.button_indicator)
		end
	end
end

--- Used when buttons need to be added to the view
-- @param position The button's position on the surface
-- @param button_size The size of button
-- @param button The button instance
-- @throws Error If the button cross the boundaries of the surface
function MultipleChoiceGrid:add_button(position, button_size, button)
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

		 self:listen_to(
		 	button,
			"toggle",
			utils.partial(self.trigger, self, "dirty")
		 )
	else
		error("screen boundary error")
	end
end

function MultipleChoiceGrid:press(button)
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
end


return MultipleChoiceGrid
