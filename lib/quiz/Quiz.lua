--- Base class for Quiz
-- @classmod Quiz
-- @field questions table with Strings representing questions
-- @field current_question counter keeping track of the current question
-- @field correct_answers counter keeping track of the correct answers
-- @field wrong_answers keeping track of the wrong answers
local class = require("lib.classy")
local questiongenerator = require("lib.quiz.questiongenerator")
local TSVReader = require("lib.quiz.TSVReader")
local NumericQuestion = require("lib.quiz.NumericQuestion")
local Quiz = class("Quiz")
--- Constructor for the Quiz class
function Quiz:__init()
	self.questions = {}
	self.current_question = 0
	self.correct_answers = 0
	self.wrong_answers = 0
	self.score = 0
end
--- Returns the next question in the quiz
-- @return String representing the next question or nil when there's no
-- questions left
function Quiz:get_question()
	self.current_question = self.current_question + 1
	if self.questions[self.current_question] == nil then
		return self.questions[self.current_question]
	end
	return self.questions[self.current_question].question
end
-- Checks if the users answer to the current question is correct
-- @return Boolean to show if the answer was correct or not
function Quiz:answer(answer)
	if self.questions[self.current_question] ~= nil then
		if self.questions[self.current_question]:is_correct(answer) == true then
			self.correct_answers = self.correct_answers + 1
		else
			self.wrong_answers = self.wrong_answers + 1
		end
	end
	return self.questions[self.current_question]:is_correct(answer)
end
-- Generates a numerical quiz of a given size and difficulty
function Quiz:generate_numerical_quiz(level, quiz_size, image_path)
	for i = 1, quiz_size do
		local question = questiongenerator.generate(level, image_path)
		self.questions[i] = question
	end
end

-- Calculate score of the quiz
-- @param representing how many correct answers of the quiz
function Quiz:calculate_score(correct_question_number)
	--maybe some other scoring algorithm
	self.score = correct_question_number * 2
end

-- Get the score of the quiz
-- @return self.score
function Quiz:get_score()
	return self.score
end

-- Generates a multiple_choice quiz of a given size
-- @param image_path representing the city now
-- @param quiz_size representing how many questions it need
-- @return true representing get the question table
-- @return false representing don't get question from TSV
function Quiz:generate_multiplechoice_quiz(image_path,quiz_size)
	local tsvreader = TSVReader(image_path)
	if tsvreader:get_question("multiple_choice") ~= false then
		for i = 1, quiz_size,1 do
			local multiplechoicequestion = tsvreader:generate_question(i)
			self.questions[i] = multiplechoicequestion
		end
		return true
	else
		return false
	end
end

-- Generates a single quiz of a given size
-- @param image_path representing the city now
-- @param quiz_size representing how many questions it need
-- @return true representing get the question table
-- @return false representing don't get question from TSV
function Quiz:generate_singlechoice_quiz(image_path,quiz_size)
	local tsvreader = TSVReader(image_path)
	if tsvreader:get_question("single_choice") ~= false then
		for i = 1, quiz_size,1 do
			local multiplechoicequestion = tsvreader:generate_question(i)
			self.questions[i] = multiplechoicequestion
		end
		return true
	else
		return false
	end
end
	-- @param attraction_number representing what attraction number you want a question for. String 1, 2 or 3.
function Quiz:generate_citytour_quiz(image_path,quiz_size,attraction_number)
	local tsvreader = TSVReader(image_path .. "_city_tour")
	if tsvreader:get_question("city_tour" .. attraction_number) ~= false then
		for i = 1, quiz_size,1 do
			local multiplechoicequestion = tsvreader:generate_question(i)
			self.questions[i] = multiplechoicequestion
		end
		return true
	else
		return false
	end
end

return Quiz
