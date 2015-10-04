--- MultipleQuestion
-- Inherits from @{Question}
-- @classmod MultipleQuestion

local class = require("lib.classy")
local Question = require("lib.quiz.Question")

local MutipleChoiceQuestion = class("MutipleChoiceQuestion", Question)

MutipleChoiceQuestion.category=""
MutipleChoiceQuestion.correct_answers_number=0
MutipleChoiceQuestion.wrong_answers_number=0
MutipleChoiceQuestion.credit=0

function MutipleChoiceQuestion:__init(image_path,question,correct_answers)
	table.sort(correct_answers)
	Question.__init(self,image_path,question,correct_answers)
end
function MutipleChoiceQuestion:get_image_path()
	return self.image_path
end
function MutipleChoiceQuestion:get_correct_answers_number()
	return self.correct_answers_number
end
function MutipleChoiceQuestion:get_wrong_answers_number()
	return self.wrong_answers_number
end
function MutipleChoiceQuestion:calculate_credit()

end
function MutipleChoiceQuestion:get_credit()
	return self.credit
end
function MutipleChoiceQuestion:set_category(category)
	self.category=category
end
function MutipleChoiceQuestion:get_category()
	return self.category
end
function MutipleChoiceQuestion:is_correct(answer)
	table.sort(answer)
	for i=1, table.maxn(self.correct_answers), 1 do
		for j=1, table.maxn(answer),1 do
			if self.correct_answers[i] ==answer[j] then
				self.correct_answers_number=self.correct_answers_number+1
				break
			end
		end
	end
	self.wrong_answers_number=table.maxn(answer)-self.correct_answers_number
	if self.wrong_answers_number==0 then
		return true
	else
		return false
	end
end
return MutipleChoiceQuestion
