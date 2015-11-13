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
local card= require("lib.components.MemoryCardComponent")
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
  self.cards = {}
  self.positions = {}

  --Components
	--Instanciate a numerical input component and make the quiz listen for changes
  --self.views.card_comp = CardComponent(remote_control)
--	self.card_surface = Surface(100,100)
  self.pairs = 4
  self.memory = MemoryGame(self.pairs, false)

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
		-- change coloir on card to visualize a move
		--if self.player_moved then
      self.player_moved = true
			self:dirty(true)
			--view.view_manager:render()
	--	end
	elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
	end
end

--Renders MemoryView and all of its child views
function MemoryView:render(surface)
--surface:clear({255, 0, 0, 255})

-- Make screen red when clicking a button
--  surface:clear({255, 0, 0, 255})

-- Colors for buttons
  local button_color = color(0, 128, 225, 255)
  local color_selected = color(33, 99, 111, 255)
  local color_disabled = color(111,222,111,255)
  local text_color = color(55, 55, 55, 255)

-- Button instance

 local pos = {x=50, y=450}
 self.pos_x = 50
 self.pos_y = 450
for i = 1, self.pairs*2 do
  self.cards[i]  = card(button_color, color_selected, color_disabled, true, false, self.memory.cards[i])
  self.pos_x = self.pos_x + 50
  pos = {x = self.pos_x, y = self.pos_y}
  self.positions[i] = pos
end

  local button_size = {width = 25, height = 50}

-- Create button grid
  self.buttonGrid = button_grid()
  for i = 1, self.pairs*2 do
  self.buttonGrid:add_button(self.positions[i], button_size, self.cards[i])
  end

-- Insert text and color to each buttonGrid
--  card_1:set_textdata("Back to City", text_color, {x = 100, y = 450}, 30,utils.absolute_path("data/fonts/DroidSans.ttf"))

  self.buttonGrid:render(surface)


if not self.listening_initiated then
  local change_callback = utils.partial(self.render, self, surface)

  self.listening_initiated = true
end

if self:is_dirty() then
  print("in dirty")
  surface:clear(color)
if self.player_moved then -- The user has moved to another card
    color = {0, 0, 255, 255}
    surface:clear(color)
    self.font:draw_over_surface(surface, "hej")
end
end

--If the user updated dirty flag will remain true to make sure the user can
-- navigate to the next question
self:dirty(false)
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
