--- ButtonGrid class.
-- This class handles the layout of buttons,
-- renders buttons on the current view, and
-- renders texts for each button.
-- Each view shall have its own ButtonGrid
-- @classmod ButtonGrid

local class = require("lib.classy")
local View = require("lib.view.View")
local button = require("lib.components.Button")
local ButtonGrid = class("ButtonGrid",View)
local subsurface = require("lib.view.Subsurface")

--- Constructor for ButtonGrid
function ButtonGrid:__init()
	View.__init(self)
	self.button_list = {} -- a list contains all buttons for the view.
	self.start_indicator = true -- will function just once, help to map the indicator with
															-- the selected button when the button grid is created.
	self.button_indicator = nil-- the indicator will point to the selected button when rendering occurs.
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
function ButtonGrid:display_text(surface, button_index)
	local button_data = self.button_list[button_index].button
	local text_button = sys.new_freetype(
									button_data.font_color:to_table(),
									button_data.font_size,
									button_data.text_position,
									button_data.font_path)

	text_button:draw_over_surface(surface, button_data.text)

end

--- Providing a subsurface to each button,
-- so the button can be rendered with its own render function.
-- If the button has text, then display the text as well
function ButtonGrid:render(surface)
-- If no button is selected when this button_grid is created,
-- then the first button in the list will be selected.
-- The indicator always points to the selected button
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

		local sub_surface = subsurface(surface,area)
			button_data.button:render(sub_surface)
		if button_data.button.text_available then
			self:display_text(surface, i)
		end
	end

end
return ButtonGrid
