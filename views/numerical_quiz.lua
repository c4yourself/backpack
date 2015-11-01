--- Question generator module. Module used for generating random numeric questions
-- @module questiongenerator

local NumericQuestion = require("lib.quiz.NumericQuestion")
local NumericalInputComponent = require("lib.components.NumericalInputComponent")
local Quiz = require("lib.quiz.Quiz")
local utils = require("lib.utils")
local event = require("lib.event")
local Event = require("lib.event.Event")
local Surface = require("emulator.surface")
--local menu = require("views.menu")

-- Generates a global numerical quiz intance
num_quiz = Quiz()
num_quiz:generate_numerical_quiz("NOVICE", 3, "image_path")

-- Module table
local numerical_quiz = {
	answer_flag = false,
	quiz_flag = false,
	--Instanciate a numerical input component and make the quiz listen for changes
	num_input_comp = NumericalInputComponent(),
	listener = Event()
}

--- Renders a surface for a numerical quiz
function numerical_quiz.render(surface)
	-- Graphics
	font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))
	surface:clear(color)
	event.remote_control:off("button_release")

	numerical_quiz.num_input_comp:set_text("12345")
	numerical_quiz.listener:listen_to(
		numerical_quiz.num_input_comp,
		"change",
		utils.partial(numerical_quiz.num_input_comp.render, surface)
	)
	numerical_quiz.listener:listen_to(
		numerical_quiz.num_input_comp,
		"submit",
		numerical_quiz.show_answer -- TODO Display result
	)
	numerical_quiz.num_input_comp:focus()

	-- Draw question
	local question = num_quiz:get_question()
	font:draw_over_surface(screen, num_quiz.current_question .. ")   " .. question .. " =  ?")

	-- Await user input
	event.remote_control:on("button_release", function(key)
		-- Checks if the user wants to progress to the next question or exit then
		-- quiz
			if key == "right" then
				if numerical_quiz.answer_flag then
					question = num_quiz:get_question()
					if question == nil then
						output = "You answered " .. num_quiz.correct_answers .. " questions correctly"
						question = ""
						numerical_quiz.quiz_flag = true
					else
						output = num_quiz.current_question .. ")   " .. question .. " =  ?"
					end
				end
			elseif key == "exit" then
				--TODO
				--	menu.render(screen)
					--gfx.update()
				--else
				--	numerical_quiz.input = numerical_quiz.input .. key
				--	output = num_quiz.current_question .. ")   " .. question .. " = " .. numerical_quiz.input
			end
		end)
end

function numerical_quiz.show_answer()
	--TODO -- Not yet implemented
	-- Reference code from old module
	--[[
	output = "Your answer is "
	if num_quiz:answer(tonumber(numerical_quiz.input)) then
		output = output .. "correct"
	else
		output = output .. "wrong"
	end
	numerical_quiz.answer_flag = true
	numerical_quiz.input = ""
	]]
end

return numerical_quiz
