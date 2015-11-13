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
local serpent = require("lib.serpent")
local button = require("lib.components.Button")


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
print("presssssssss")
print(key)
if key == "down" then
  print("down1")
  -- the indicator refers to the selecting button
  local indicator = self.buttonGrid.button_indicator
  local button_list = self.buttonGrid.button_list

  indicator = indicator % #button_list + 1

  button_list[indicator].button:select(true)

  if indicator == 1 then
    button_list[#button_list].button:select(false)
  else
    button_list[indicator-1].button:select(false)
  end

  self.buttonGrid.button_indicator = indicator

  self:dirty(true)
  --gfx.update()
elseif key == "up" then
  print("up2")
  local indicator = self.buttonGrid.button_indicator
  local button_list = self.buttonGrid.button_list
  indicator = indicator - 1
  if indicator == 0 then
    indicator = #self.buttonGrid.button_list
  end
  button_list[indicator].button:select(true)

  if indicator == #button_list then
    button_list[1].button:select(false)
  else
    button_list[indicator+1].card:select(false)
  end

  self.buttonGrid.button_indicator = indicator
  self:dirty(true) --use the view's button grid for rendering

  --gfx.update()
-- end
--   --if key == "right" or key == "up" or key == "down" or key == "left" then
-- 		-- change coloir on card to visualize a move
-- 		if self.player_moved then
--       self.player_moved = true
-- 			self:dirty(true)
--       self.cards[2]:select()
--       self.buttonGrid:render(surface)
-- 			--view.view_manager:render()
-- 		end
elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
end
end

function MemoryView:_print_board()
  -- Colors for buttons
    local button_color = color(0, 128, 225, 255)
    local color_selected = color(33, 99, 111, 255)
    local color_disabled = color(111,222,111,255)
    local text_color = color(55, 55, 55, 255)

    local button_size = {width = 25, height = 25}
  self.buttonGrid = button_grid()
  self.pos_x = 450
  self.pos_y = 50
  local columns = math.ceil((self.pairs*2)^(1/2))
  for i = 1, self.pairs*2 do
    self.cards[i]  = button(button_color, color_selected, color_disabled, true, false)
    if i == 1 then
      self.pos_x = self.pos_x
    elseif ((i-1) % columns == 0) then
      self.pos_y = self.pos_y + 50
      self.pos_x = self.pos_x - (columns - 1) * 50
    else
      self.pos_x = self.pos_x + 50
    end
  self.positions[i] = {x = self.pos_x, y = self.pos_y}
  self.buttonGrid:add_button(self.positions[i], button_size, self.cards[i])
  end
  self:dirty(true)
  --self.buttonGrid:render(surface)
end

--Renders MemoryView and all of its child views
function MemoryView:render(surface)
-- Create cards and cardgrid using buttonGrid
-- Draws the board depending on the chosen abount of pairs
  self:_print_board()

if not self.listening_initiated then
  local change_callback = utils.partial(self.render, self, surface)
  self.listening_initiated = true
end

if self:is_dirty() then
  --print("in dirty")
  --surface:clear(color)
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
