--- Base class for TSVReader
-- @classmod TSVReader
-- @field filename Current city
-- @field questions_table questions from TSV files
-- @field choices choices of multiple choice questions
-- @field correct_answers correct answers of questions
-- @field question_index used for generating random

local class = require("lib.classy")
local utils = require("lib.utils")
local TSVReader = class("TSVReader")
local MultipleChoiceQuestion = require("lib.quiz.MultipleChoiceQuestion")


TSVReader.filename = ""
TSVReader.questions_table = {}
TSVReader.choices = {}
TSVReader.correct_answers = {}
TSVReader.question_index = {}

function TSVReader:__init(filename)
	self.filename = filename
end

--- Convert string answers to integer
-- @param answers correct answer table as string
-- @return correct answer table as integer
function TSVReader:get_correct_answers(answers)
	local output = {}
	local tmp = {}
	tmp = utils.split(answers," ")

	for i = 1, #tmp, 1 do
		table.insert(output,tonumber(tmp[i]))
	end

	return output
end

-- Read questions from TSV file
-- @param question_type multiple_choice, single_choice or numeric
-- @return self.questions_table representing get the question table
-- @return false representing don't get question from TSV file
function TSVReader:get_question(question_type)

	local tmp_table = {}
	self.filename = utils.absolute_path(string.format("data/questions/%s.tsv",self.filename))

	--if(lfs.attributes(self.filename, "mode") == "file") then

		--get the questions from TSV file
		for line in io.lines(self.filename) do
			if string.sub(line,1,string.len(question_type)) == question_type then
				table.insert(tmp_table,string.sub(line,string.len(question_type) + 2,#line))
			end
		end

		--generate a question table
		for i = 1,#tmp_table,1 do
			table.insert(self.questions_table,utils.split(tmp_table[i],"\t"))
		end

		--seperate the data in question table to get questions, choices and correct answers
		for i = 1,#self.questions_table,1 do
			table.insert(self.question_index,i)
			table.insert(self.choices,utils.split(self.questions_table[i][2],";"))
			table.insert(self.correct_answers,self:get_correct_answers(self.questions_table[i][3]))
		end

		return self.questions_table
end

---Generate random table
function TSVReader:generate_random(tabNum,indexNum)
	indexNum = indexNum or tabNum
	local t = {}
	local rt = {}
	math.randomseed(os.time())

	for i = 1, indexNum do
		local ri = math.random(1, tabNum + 1 - i)
		local v = ri

		for j = 1,tabNum do
			if not t[j] then
				ri = ri - 1
				if ri == 0 then
					table.insert(rt,j)
					t[j] = true
				end
			end
		end
	end
	return rt
end

-- Return a random question to generator in Quiz
-- @param count representing question[count]
-- @return question representing the instance of MultipleChoiceQuestion
function TSVReader:generate_question(count)
	local seed = self.generate_random(#self.question_index,#self.question_index)

	local count = self.question_index[seed[count]]

	local question = MultipleChoiceQuestion(self.image_path,self.questions_table[count][1],self.correct_answers[count],self.choices[count])
	return question
end

return TSVReader
