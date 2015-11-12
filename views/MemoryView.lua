--- Base class for MemoryView
-- @classmod MemoryView
--- Constructor for NumericQuizView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local MemoryGame = require("lib.memory.Memory")
local Surface = require("emulator.surface")
local utils = require("lib.utils")
local MemoryView = class("MemoryView", View)
local button= require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")


function MemoryView:__init()
  View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

  -- Flags
	--Flags to determine whether a quiz or a question is answered
	self.player_moved = false
	self.player_ok = false
	self.listening_initiated = false

  --Components
	--Instanciate a numerical input component and make the quiz listen for changes
	self.input_surface = Surface(300,100)
  local pairs = 8
  self.memory = MemoryGame(pairs, false)

  -- Graphics
  self.font = sys.new_freetype(
    {r = 255, g = 255, b = 255, a = 255},
    32,
    {x = 100, y = 300},
    utils.absolute_path("data/fonts/DroidSans.ttf"))

  -- Listeners and callbacks
  self:listen_to(
    event.remote_control,
    "button_release",
    utils.partial(self.press, self)
  )
end

--
function MemoryView:press(key)
  if key == "right" or key == "up" or key == "down" or key == "left" then
		-- change color on card to visualize a move
		--if self.player_moved then
      self.player_moved = true
			self:dirty(true)
      print("key is: " .. key)
			--view.view_manager:render()
	--	end
  elseif key == "7" then
    self.back_to_city_pressed = true
    print("pressed")
    self:dirty(true)
	elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
	end
end

--Renders MemoryView and all of its child views
function MemoryView:render(surface)
-- Make screen red when clicking a button
--  surface:clear({255, 0, 0, 255})

-- Colors for buttons
  local button_color = color(0, 128, 225, 255)
  local color_selected = color(33, 99, 111, 255)
  local color_disabled = color(111,222,111,255)
  local text_color = color(255, 255, 255, 255)

-- Button instance
  local button_1 = button(button_color, color_selected, color_disabled, true, false)
--  local button_2 = button(button_color, color_selected, color_disabled, false, false)

-- Button size and position
  local position_1 = {x = 100, y = 450}
--  local position_2 = {x = 100, y = 150}
  local button_size = {width = 300, height = 100}

-- Create button grid
  self.buttonGrid = button_grid()
  self.buttonGrid:add_button(position_1, button_size, button_1)
--  self.buttonGrid:add_button(position_2, button_size, button_2)


-- Insert text and color to each buttonGrid
  button_1:set_textdata("Back to City", text_color, {x = 100, y = 450}, 30, utils.absolute_path("data/fonts/DroidSans.ttf"))
  --button_2:set_textdata("Turns", text_color, {x = 100, y = 150}, 30, utils.absolute_path("data/fonts/DroidSans.ttf"))

-- Add the number of turns
  local turns_text =sys.new_freetype(text_color:to_table(), 30, {x = 100, y = 110}, utils.absolute_path("data/fonts/DroidSans.ttf"))
  local turns = sys.new_freetype(text_color:to_table(), 30, {x = 100, y = 150}, utils.absolute_path("data/fonts/DroidSans.ttf"))
  turns_text:draw_over_surface(surface, "Turns")
  if self.memory.moves == nil then
    turns:draw_over_surface(surface, "No turns...")
  else
    turns:draw_over_surface(surface, self.memory.moves)
  end
  self.buttonGrid:render(surface)


if not self.listening_initiated then
  local change_callback = utils.partial(self.render, self, surface)
  self.listening_initiated = true
end

  if self:is_dirty() then
--  print("in dirty")
--  surface:clear(color)
  if self.player_moved then -- The user has moved to another card
--    color = {0, 0, 255, 255}
--    surface:clear(color)
--    self.font:draw_over_surface(surface, "hej")
  if self.back_to_city_pressed then
    print("Open pop_")
    self:back_to_city()
  end
end
end

--If the user updated dirty flag will remain true to make sure the user can
-- navigate to the next question
self:dirty(false)
end

function MemoryView:back_to_city()
-- TODO Implement/connect pop-up for quit game
-- Appendix 2 in UX design document
  print("hello")
end

function MemoryView:get_turns()

end

-- Displays the correct answer and whether the user chose the correct one.
-- function NumericQuizView:show_answer()
-- if self.views.num_input_comp:get_text() ~= "" then
--   self.answer_flag = true
--   self:dirty(true)
--   self.user_answer = tonumber(self.views.num_input_comp:get_text())
--   self.views.num_input_comp:set_text(nil)
--   view.view_manager:render()
-- end
-- end

return MemoryView
