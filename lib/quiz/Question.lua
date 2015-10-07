--- Base class for Question
-- @classmod Question
-- @field image_path
-- @field question
-- @field correct_answers

local class = require("lib.classy")

local Question = class("Question")
local utils = require("lib.utils")
--local font = require("fonts")

Question.image_path = ""
Question.question = ""
Question.correct_answers = {}

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

function Question: show(font,textColor,surface)
local something = sys.new_freetype({r=textColor[1],g=textColor[2],b=textColor[3]}, 30, {x=200,y=80}, utils.absolute_path("data/fonts/"..font..".ttf"))
 something : draw_over_surface(surface,self.question)
end

function Question:is_correct(answer)
end
return Question
