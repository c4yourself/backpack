local luaunit = require("luaunit")
local class = require("lib.classy")
local Question = require("lib.quiz.Question")
local NumericQuestion = require("lib.quiz.NumericQuestion")


local TestNumerical = {}

function TestNumerical:setUp()
	num_q = NumericQuestion("", "11+1", 12)
end

function TestNumerical:test_is_correct()
	luaunit.assertEquals(num_q:is_correct(12), true)
end

return TestNumerical
