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
	elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
	end
end

--Renders MemoryView and all of its child views
function MemoryView:render(surface)
surface:clear({255, 0, 0, 255})
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
