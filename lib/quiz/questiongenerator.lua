--- Question generator module. Module used for generating random numeric questions
-- @module questiongenerator

-- Module table
local questiongenerator = {}

-- table mapping the constant difficulty levels to the number of operands that
-- will be included in the question
questiongenerator.diff_operand_map = {
	["BEGINNER"] = 2;
	["NOVICE"] = 3;
	["ADVANCED"] = 4;
	["EXPERT"] = 8
}

-- table mapping different difficulty levels to different operators
questiongenerator.token_table = {
	["BEGINNER"] = {"+";"-"},
	["NOVICE"] = {"+";"-";"*"},
	["ADVANCED"] = {"+";"-";"*";"/"},
	["EXPERT"] = {"+";"-";"*";"/"}
}

--- Generates a numerical (arithmetic) question based on the difficulty level
-- Input string should be one of the constants in the questiongenerator module,
-- i.e. BEGINNER, NOVICE, ADVANCED, or EXPERT
-- @param difficulty String representing the difficulty level
-- @return question Mathematical expression as a String
-- @return answer The correct answer to the question as a Number
function questiongenerator.generate(level)
	local number_of_operands = questiongenerator.diff_operand_map[level]
	local tokens = questiongenerator.token_table[level]
	local question = ""

	math.randomseed(os.time())
	question = "" .. math.random(10)
	for i=1, number_of_operands-1 do
		question = question .. tokens[math.random(#tokens)]
		question = question .. math.random(10)
	end
	answer = load("return " .. question)()
	return question, answer
end

return questiongenerator
