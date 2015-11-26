--- Base class for Question
-- @classmod Question
-- @field image_path
-- @field question
-- @field correct_answers

local class = require("lib.classy")
local Question = class("Question")
local utils = require("lib.utils")

Question.image_path = ""
Question.question = ""
Question.correct_answers = {}

---Constructor for Question
-- @param image_path string
-- @param question string representing question
-- @param correct_answers table representing the correct answers
function Question:__init(image_path,question,correct_answers)
	if image_path ~= nil then
		self.image_path = image_path
	end
	if question ~= nil then
		self.question = question
	end
	if correct_answers ~= nil then
		self.correct_answers = correct_answers
	end
end

return Question
