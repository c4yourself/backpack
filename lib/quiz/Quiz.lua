--- Base class for Quiz
-- @classmod Quiz
-- @field questions table with Strings representing questions
-- @field current_question counter keeping track of the current question
-- @field correct_answers counter keeping track of the correct answers
-- @field wrong_answers keeping track of the wrong answers

local class = require("lib.classy")
local questiongenerator = require("lib.quiz.questiongenerator")
local NumericQuestion = require("lib.quiz.NumericQuestion")
local Quiz = class("Quiz")

--- Constructor for the Quiz class
function Quiz:__init()
	self.questions = {}
	self.current_question = 0
	self.correct_answers = 0
	self.wrong_answers = 0
end

--- Returns the next question in the quiz
-- @return String representing the next question
function Quiz:get_question()
	self.current_question = self.current_question + 1
	return self.questions[self.current_question].question
end

--- Checks if the users answer to the current question is correct
-- @return Boolean to show if the answer was correct or not
function Quiz:answer(answer)
	return self.questions[self.current_question]:is_correct(answer)
end

-- Generates a numerical quiz of a given size and difficulty
function Quiz:generate_numerical_quiz(level, quiz_size, image_path)
	--TODO image_path needs to be properly implemented
	for i=1, quiz_size do
		local question, answer = questiongenerator.generate(level)
		local question = NumericQuestion(image_path, question, answer)
		self.questions[i] = question
	end
end

return Quiz
