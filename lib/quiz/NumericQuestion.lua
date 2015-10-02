--- Base class for NumericQuestion
-- @classmod NumericQuestion

local class = require("lib.classy")

local NumericQuestion = class("NumericQuestion")

--- Constructor for NumericQuestion
-- @param image_path path to the image as a string
-- @param question string
-- @param correct_answer number representing the correct answer
function NumericQuestion:__init(image_path, question, correct_answer)
	self.correct_answer = correct_answer
	self.question = question
end

--- Creates a random mathematical question
-- @param level difficulty of the question generated
--function NumericQuestion:_create_question(level)
--	print("TODO: Implement random generator")
--	return "1+1"
--end

-- Evaluates if a mathematical expression is correct
-- @param user_answer Number representing the user answer
function NumericQuestion:_is_correct (user_answer)
	return user_answer == load("return " .. self.question)()
end

return NumericQuestion
