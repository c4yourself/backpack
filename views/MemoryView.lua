--- Base class for MemoryView
-- @classmod MemoryView

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

-- Flags to determine whether a player has moved or pressed submit
	self.player_moved = false
	self.player_ok = false
	self.listening_initiated = false
  self.cards = {}
  self.positions = {}

-- Components
-- Instanciate a numerical input component and make the quiz listen for changes
-- self.views.card_comp = CardComponent(remote_control)
--	self.card_surface = Surface(100,100)

  self.pairs = 4
  self.memory = MemoryGame(self.pairs, false)

  --self:_print_board();
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


function MemoryView:press(key)
  if key == "right" then
    self.player_moved = true
		self:dirty(true)

  elseif key == "7" then
    self.back_to_city_pressed = true
    self:dirty(true)

  elseif key == "down" then
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

  elseif key == "up" then

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
  self:dirty(true)

  elseif key == "back" then
		self:trigger("exit")
  end
end

function MemoryView:_print_board()
  -- Colors for buttons
--     local button_color = color(0, 128, 225, 255)
--     local color_selected = color(33, 99, 111, 255)
--     local color_disabled = color(111,222,111,255)
--     local text_color = color(55, 55, 55, 255)
--
--     local button_size = {width = 25, height = 25}
--     self.buttonGrid = button_grid()
--     self.pos_x = 450
--     self.pos_y = 50
--     local columns = math.ceil((self.pairs*2)^(1/2))
--
--     for i = 1, self.pairs*2 do
--       self.cards[i]  = button(button_color, color_selected, color_disabled, true, false)
--
--       if i == 1 then
--         self.pos_x = self.pos_x
--       elseif ((i-1) % columns == 0) then
--         self.pos_y = self.pos_y + 50
--         self.pos_x = self.pos_x - (columns - 1) * 50
--       else
--         self.pos_x = self.pos_x + 50
--       end
--       self.positions[i] = {x = self.pos_x, y = self.pos_y}
--       self.buttonGrid:add_button(self.positions[i], button_size, self.cards[i])
--     end
-- --  self:dirty(true)
--     self.buttonGrid:render(surface)
end

-- Renders MemoryView and all of its child views
function MemoryView:render(surface)
  local button_color = color(0, 128, 225, 255)
  local color_selected = color(33, 99, 111, 255)
  local color_disabled = color(111,222,111,255)
  local text_color = color(255, 255, 255, 255)
  local button_size = {width = 25, height = 25}

  self.buttonGrid = button_grid()
  local button_1 = button(button_color, color_selected, color_disabled, true, false)
  local position_1 = {x = 100, y = 450}
  self.pos_x = 450
  self.pos_y = 50
  local button_size_big = {width = 300, height = 100}
  local columns = math.ceil((self.pairs*2)^(1/2))

  self.buttonGrid:add_button(position_1, button_size_big, button_1)
  button_1:set_textdata("Back to City", text_color, {x = 100, y = 450}, 30, utils.absolute_path("data/fonts/DroidSans.ttf"))

-- Add the number of turns
  local turns_text =sys.new_freetype(text_color:to_table(), 30, {x = 100, y = 110}, utils.absolute_path("data/fonts/DroidSans.ttf"))
  local turns = sys.new_freetype(text_color:to_table(), 30, {x = 100, y = 150}, utils.absolute_path("data/fonts/DroidSans.ttf"))
  turns_text:draw_over_surface(surface, "Turns")

  if self.memory.moves == nil then
    turns:draw_over_surface(surface, "No turns...")
  else
    turns:draw_over_surface(surface, self.memory.moves)
  end

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
    self.buttonGrid:render(surface)

  if not self.listening_initiated then
    local change_callback = utils.partial(self.render, self, surface)
    self.listening_initiated = true
  end

  if self:is_dirty() then

  elseif self.back_to_city_pressed then
      self:back_to_city()
  end

  self:dirty(false)
end

function MemoryView:back_to_city()
-- TODO Implement/connect pop-up for quit game
-- Appendix 2 in UX design document
end


return MemoryView
