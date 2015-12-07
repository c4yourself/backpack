--- Question generator module. Module used for generating random numeric questions
-- @module questiongenerator

-- Module table
local questiongenerator = {}
local NumericQuestion = require("lib.quiz.NumericQuestion")

-- table mapping the constant difficulty levels to the number of operands that
-- will be included in the question
questiongenerator.diff_operand_map = {
	["BEGINNER"] = 2,
	["NOVICE"] = 3,
	["ADVANCED"] = 4,
	["EXPERT"] = 8
}

-- table mapping different difficulty levels to different operators
questiongenerator.token_table = {
	["BEGINNER"] = {"+"},
	["NOVICE"] = {"+","*"},
	["ADVANCED"] = {"+","*"},
	["EXPERT"] = {"+","*"}
}

questiongenerator.seed = os.time()
questiongenerator.var = math.randomseed(questiongenerator.seed)

--- Generates a numerical (arithmetic) question based on the difficulty level
-- Input string should be one of the constants in the questiongenerator module,
-- i.e. BEGINNER, NOVICE, ADVANCED, or EXPERT
-- @param difficulty String representing the difficulty level
-- @param image_path String with search path to a image, in case of a image
--					question.
-- @return NumericQuestion instance
function questiongenerator.generate(difficulty, image_path)
	local operators, operands = questiongenerator._generate_ops(difficulty)
	local question, answer  = questiongenerator._build_expression(operators, operands)
	local num_q = NumericQuestion(image_path, question, answer)
	return num_q
end

--- Generates a set of random operators and a set of random operands
-- @param difficulty String indicating which difficulty to use
-- @return operators, a table with operands matching the difficulty level
-- @return operands, a table with operands matching the difficulty level
function questiongenerator._generate_ops(difficulty)
	local number_of_operands = questiongenerator.diff_operand_map[difficulty]
	local tokens = questiongenerator.token_table[difficulty]
	local operands = {}
	local operators = {}

	operands[1] = math.random(10)
	for i=1, number_of_operands-1 do
		operators[i] = tokens[math.random(#tokens)]
		operands[i+1] = math.random(10)
	end

	return operators, operands
end

---Builds a mathematical expression given operators and operands
-- Note: #operands needs to be #operators + 1
-- @param operators Table with operators to use
-- @param operands Table with operands to use
-- @return String representing a mathematical expression and the correct answer
-- @return Number answer to the question
function questiongenerator._build_expression(operators, operands)
	local question = ""

	questiongenerator.seed = questiongenerator.seed + 13
	question = "" .. operands[1]
	for i=2, #operands do
		question = question .. operators[i-1]
		question = question .. operands[i]
	end

	local answer = loadstring("return " .. question)()
	return question, answer
end

return questiongenerator
