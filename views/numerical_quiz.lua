--- Question generator module. Module used for generating random numeric questions
-- @module questiongenerator

local NumericQuestion = require("lib.quiz.NumericQuestion")
local Quiz = require("lib.quiz.Quiz")
local utils = require("lib.utils")
local event = require("lib.event")

-- Generates a global numerical quiz intance
num_quiz = Quiz()
num_quiz:generate_numerical_quiz("NOVICE", 3, "image_path")

-- Module table
local numerical_quiz = {
	input = "",
	answer_flag = false,
	quiz_flag = false
}

--- Renders a surface for a numerical quiz
function numerical_quiz.render(surface)
	surface:clear(color)
	event.remote_control:off("button_release")
	local question = num_quiz:get_question()
	local output = ""

	font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))

	--if numerical_quiz.quiz_flag ~= false then
		-- Print quiz is over
		--font:draw_over_surface(screen, "You answered " .. num_quiz.correct_answers .. " questions correctly")
	--else
		-- Draw question
		font:draw_over_surface(screen, num_quiz.current_question .. ")   " .. question .. " =  ?")
		-- Await user input
		event.remote_control:on("button_release", function(key)

			-- If: the user are pressing a number key
			if key == "backspace" then
				if #numerical_quiz.input > 0 then
					numerical_quiz.input = numerical_quiz.input:sub(1,-2)
					output = num_quiz.current_question .. ")   " .. question .. " = " .. numerical_quiz.input
				end
			elseif key == "ok" then
				--Show if question is correct
				output = "Your answer is "
				if num_quiz:answer(tonumber(numerical_quiz.input)) then
					output = output .. "correct"
				else
					output = output .. "wrong"
				end
				numerical_quiz.answer_flag = true
				numerical_quiz.input = ""
			elseif key == "right" then
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
			else
				numerical_quiz.input = numerical_quiz.input .. key
				output = num_quiz.current_question .. ")   " .. question .. " = " .. numerical_quiz.input
			end
			surface:clear(color)
			font:draw_over_surface(screen, output)
			gfx.update()

		end)
	--end
end

return numerical_quiz
