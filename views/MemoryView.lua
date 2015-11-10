--- Base class for MemoryView
-- @classmod MemoryView
--- Constructor for NumericQuizView

local class = require("lib.classy")
local View = require("lib.view.View")
local event = require("lib.event")
local memory = require("lib.memory.Memory")
local Surface = require("emulator.surface")
local utils = require("lib.utils")

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
  self.memory = Memory(pairs, false)

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
		if self.player_moved then
			self:dirty(true)
			self.answer_flag = false
			view.view_manager:render()
		end
	elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
	end
end

--Renders MemoryView and all of its child views
function MemoryView:render(surface)
if not self.listening_initiated then
  local change_callback = utils.partial(self.render, self, surface)
  self.listening_initiated = true
end

if self:is_dirty() then
  surface:clear(color)
  if self.player_moved then -- The user has moved to another card
    color = {0, 0, 255, 0}
    surface:clear(color)
    self.font:draw_over_surface(surface, output)
  else
    --Render the main components of NumericQuizView
    self.answer_flag = false
    surface:clear(color)
    local question = self.num_quiz:get_question()
    if question ~= nil then
      self.font:draw_over_surface(surface, self.num_quiz.current_question .. ")   " .. question .. " =  ?")
    else
      -- The user has finished the quiz
      self.views.num_input_comp:blur()
      -- TODO show result of the quiz
      self.quiz_flag = true -- Quiz is complete
      output = "You answered " .. tostring(self.num_quiz.correct_answers) .. " questions correctly."
      self.font:draw_over_surface(surface, output)
    end
  end
end
-- Render all child views and copy changes to this view
-- Render input component
self.views.num_input_comp:render(self.input_surface)
surface:copyfrom(self.input_surface)

gfx.update()
--If the user updated dirty flag will remain true to make sure the user can
-- navigate to the next question
self:dirty(false)
end

-- Displays the correct answer and whether the user chose the correct one.
function NumericQuizView:show_answer()
if self.views.num_input_comp:get_text() ~= "" then
  self.answer_flag = true
  self:dirty(true)
  self.user_answer = tonumber(self.views.num_input_comp:get_text())
  self.views.num_input_comp:set_text(nil)
  view.view_manager:render()
end
end

return MemoryView
