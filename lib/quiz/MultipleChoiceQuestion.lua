--- MultipleQuestion
-- Inherits from @{Question}
-- @classmod MultipleQuestion

local class = require("lib.classy")
local Question = require("lib.quiz.Question")

local MultipleChoiceQuestion = class("MultipleChoiceQuestion", Question)

MultipleChoiceQuestion.category = ""
MultipleChoiceQuestion.correct_answers_number = 0
MultipleChoiceQuestion.wrong_answers_number = 0
MultipleChoiceQuestion.credit = 0

MultipleChoiceQuestion.correct_answers = {}
MultipleChoiceQuestion.Choices = {}

function MultipleChoiceQuestion:__init(image_path,question,correct_answers,choices)
	table.sort(correct_answers)
	self.image_path = image_path
	self.question = question
	self.correct_answers = correct_answers
	self.Choices = choices
	--Question.__init(self,image_path,question,correct_answers)
end
function MultipleChoiceQuestion:get_image_path()
	return self.image_path
end
function MultipleChoiceQuestion:set_choices(choice)
	for i = 1, 4, 1 do
		self.Choices[i] = choice[i]
	end
end
function MultipleChoiceQuestion:get_choices()
	return self.Choices
end
function MultipleChoiceQuestion:get_correct_answers_number()
	return self.correct_answers_number
end
function MultipleChoiceQuestion:get_wrong_answers_number()
	return self.wrong_answers_number
end
function MultipleChoiceQuestion:calculate_credit()

end
function MultipleChoiceQuestion:get_credit()
	return self.credit
end
function MultipleChoiceQuestion:set_category(category)
	self.category = category
end
function MultipleChoiceQuestion:get_category()
	return self.category
end
function MultipleChoiceQuestion:is_correct(answer)
	table.sort(answer)
	table.sort(self.correct_answers)
	result_flag = 0
	if #answer ~= #self.correct_answers then
		return false
	else
		for i = 1,#self.correct_answers,1 do
			print(self.correct_answers[i])
			print(answer[i])
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
