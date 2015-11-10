local class = require("classy")
local MultipleChoiceQuestion=require("quiz.MultipleChoiceQuestion")
local SingleChoiceQuestion = class("SingleChoiceQuestion",MultipleChoiceQuestion)


function SingleChoiceQuestion:__init(image_path,question,correct_answers)
	MultipleChoiceQuestion.__init(self,image_path,question,correct_answers)
	self.correct_answer=self.correct_answers[1]
end

function SingleChoiceQuestion:is_correct(answer)
	return self.correct_answer==answer
end
return SingleChoiceQuestion
