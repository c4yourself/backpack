--- Question generator module. Module used for generating random numeric questions
-- @module questiongenerator

local NumericQuestion = require("lib.quiz.NumericQuestion")
local Quiz = require("lib.quiz.Quiz")
local utils = require("lib.utils")

-- Generates a global numerical quiz intance
num_quiz = Quiz()
num_quiz:generate_numerical_quiz("NOVICE", 10, "image_path")

-- Module table
local numerical_quiz = {}

--- Renders a surface for a numerical quiz
function numerical_quiz.render(surface)
	surface:clear(color)

	local question = num_quiz:get_question()


		font = sys.new_freetype(
			{r = 255, g = 255, b = 255, a = 255},
			32,
			{x = 100, y = 300},
			utils.absolute_path("data/fonts/DroidSans.ttf"))

	if question == nil then
		-- Print quiz is over
		font:draw_over_surface(screen, "You answered " .. num_quiz.correct_answers .. " questions correctly")
	else
		-- Draw question
		font:draw_over_surface(screen, question .. " =  ?")
		-- Await user input

		-- Show if question is correct
		--answer = 1
		--local output = "Your answer is "
		--if num_quiz:answer(answer) then
		--	output = output .. "correct"
		--else
		--	output = output .. "wrong"
		--end

		--font:draw_over_surface(screen, output)



	end
end

return numerical_quiz
