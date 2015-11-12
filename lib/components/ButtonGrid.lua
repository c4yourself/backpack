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
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local multiplechoice_quiz = require("views.multiplechoice_quiz")
local NumericalQuizView = require("views.NumericalQuizView")
local event = require("lib.event")
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
	-- 	print("I button grid")
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
function ButtonGrid:display_text(surface, button_index)
	local button_data = self.button_list[button_index].button
	local text_button = sys.new_freetype(
									button_data.font_color:to_table(),
									button_data.font_size,
									button_data.text_position,
									button_data.font_path)

	text_button:draw_over_surface(surface, button_data.text)

end

function ButtonGrid:press(button)

    if button == "down" then
			self:indicate_downward(self.button_indicator)
			self:trigger("dirty")
		elseif button == "up" then
			self:indicate_upward(self.button_indicator)
			self:trigger("dirty")
		elseif button == "1" then
				--Instanciate a numerical quiz
				local numerical_quiz_view = NumericalQuizView()
				--Stop listening to everything
				-- TODO
				-- Start listening to the exit event, which is called when the user
				-- exits a quiz

				--Update the view
				numerical_quiz_view:render(screen)
				-- TODO This should be done by a subsurface in the final version
				gfx.update()
		elseif button == "2" then
				multiplechoice_quiz.render(screen)
				gfx.update()
		elseif button == "3" then
				print("Shut down program")
				sys.stop()

	end
	print("the indicator is now " .. self.button_indicator)
	collectgarbage()  --ensure that memory-leak does not occur
	-- print out the memory usage in KB
	print("the memory usage is " .. collectgarbage("count")*1024)

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

		local sub_surface = SubSurface(surface,area)
			button_data.button:render(sub_surface)
      if button_data.button.text_available then
			self:display_text(surface, i)
	   end
   end
end

--- When "down" is pressed, the indicator shall follow the down-direction
-- @param button_indicator The current indicator that points to the selected button
function ButtonGrid:indicate_downward(button_indicator)
  local indicator = button_indicator
    local button_list = self.button_list

    indicator = indicator % #button_list
    indicator = indicator + 1
    button_list[indicator].button:select(true)

     if indicator == 1 then
     button_list[#button_list].button:select(false)
   else
    button_list[indicator-1].button:select(false)
   end

   self.button_indicator = indicator
end

--- When "up" is pressed, the indicator shall follow the up-direction
-- @param button_indicator The current indicator that points to the selected button
function ButtonGrid:indicate_upward(button_indicator)
  local indicator = button_indicator
  local button_list = self.button_list

  indicator = indicator - 1

  if indicator == 0 then
  indicator = #button_list
  end

  button_list[indicator].button:select(true)

  if indicator == #button_list then
  button_list[1].button:select(false)
  else
  button_list[indicator+1].button:select(false)
  end

  self.button_indicator = indicator
end


return ButtonGrid
