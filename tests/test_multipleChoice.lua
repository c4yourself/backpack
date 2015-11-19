local luaunit = require("luaunit")
local class = require("lib.classy")
local Question = require("lib.quiz.Question")
local MultipleChoiceQuestion = require("lib.quiz.MultipleChoiceQuestion")

local TestMultipleChoice = {}

--Sets up test by creating a test object
function TestMultipleChoice:setUp()
	questionSingleCorrect = MultipleChoiceQuestion("image_path", "question", {1}, {"1","2","3","4"})
	questionMultipleCorrect = MultipleChoiceQuestion("image_path2", "question2", {1,2}, {"1","2","3","4"})
end

function TestMultipleChoice:test_get_image_path()
	luaunit.assertEquals(questionSingleCorrect:get_image_path(),questionSingleCorrect.image_path)
end

function TestMultipleChoice:test_get_choices()
	luaunit.assertEquals(questionSingleCorrect:get_choices(), questionSingleCorrect.choices)
end

function TestMultipleChoice:test_get_credt()
	luaunit.assertEquals(questionSingleCorrect:get_credit(), questionSingleCorrect.credit)
end

function TestMultipleChoice:test_get_category()
	luaunit.assertEquals(questionSingleCorrect:get_category(),questionSingleCorrect.category)
end

function TestMultipleChoice:test_is_correct_answer()
	luaunit.assertEquals(questionSingleCorrect:is_correct({1}), true);
	luaunit.assertEquals(questionSingleCorrect:is_correct({2}),false);
	luaunit.assertEquals(questionMultipleCorrect:is_correct({1,2}),true);
	luaunit.assertEquals(questionMultipleCorrect:is_correct({1,3}),false);
end

return TestMultipleChoice
