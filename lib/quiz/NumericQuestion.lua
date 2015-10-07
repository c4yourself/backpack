--- Base class for NumericQuestion
-- @classmod NumericQuestion

local class = require("lib.classy")
local Question = require("lib.quiz.Question")

local NumericQuestion = class("NumericQuestion", Question)

--- Constructor for NumericQuestion
-- @param image_path path to the image as a string
-- @param question string representing a mathematical expression
-- @param correct_answer number representing the correct answer
function NumericQuestion:__init(image_path, question, correct_answer)
	Question.__init(self, image_path, question, correct_answer)
	self.correct_answer = correct_answer
end

-- Evaluates if a mathematical expression is correct
-- @param user_answer Number representing the user answer
-- @return Boolean value
function NumericQuestion:is_correct (user_answer)
	print("user answer: " .. user_answer)
	print("correct_answer: " .. self.correct_answer)
	return user_answer == self.correct_answer
end

return NumericQuestion
