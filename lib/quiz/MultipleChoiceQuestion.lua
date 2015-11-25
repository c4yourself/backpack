--- MultipleQuestion
-- Inherits from @{Question}
-- @classmod MultipleQuestion

local class = require("lib.classy")
local Question = require("lib.quiz.Question")

local MultipleChoiceQuestion = class("MultipleChoiceQuestion", Question)

MultipleChoiceQuestion.correct_answers = {}
MultipleChoiceQuestion.Choices = {}

---Constructor for MultipleQuestion
-- @param image_path string
-- @param question string representing question
-- @param correct_answers table representing the correct answers
-- @param choices table representing the choices of the question
function MultipleChoiceQuestion:__init(image_path,question,correct_answers,choices)
	table.sort(correct_answers)
	self.image_path = image_path
	self.question = question
	self.correct_answers = correct_answers
	self.Choices = choices
	--Question.__init(self,image_path,question,correct_answers)
end

---Get image_path of the question
-- @return image_path
function MultipleChoiceQuestion:get_image_path()
	return self.image_path
end

---Set choice of the question
-- @param choice
function MultipleChoiceQuestion:set_choices(choice)
	for i = 1, 4, 1 do
		self.Choices[i] = choice[i]
	end
end

---Get Choices of the question
-- @return Choices
function MultipleChoiceQuestion:get_choices()
	return self.Choices
end

---Check the answer is right or not
-- @param answer table representing the answer from user
-- @return true right answer
-- @return false wrong answer
function MultipleChoiceQuestion:is_correct(answer)
	table.sort(answer)
	table.sort(self.correct_answers)
	result_flag = 0

	if #answer ~= #self.correct_answers then
		return false
	else
		for i = 1,#self.correct_answers,1 do
			if self.correct_answers[i] ~= answer[i] then
				result_flag =- 1
				break
			end
		end
	end
	if result_flag == -1 then
		return false
	else
		return true
	end
end

return MultipleChoiceQuestion
