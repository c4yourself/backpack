local luaunit = require("luaunit")
local class = require("lib.classy")
local Question = require("lib.quiz.Question")
local TSVReader = require("lib.quiz.TSVReader")

local TestTSVReader = {}

--Sets up test by creating a test object
function TestTSVReader:setUp()
  tsvreader = TSVReader("paris")
end

function TestTSVReader:test_get_question()
  luaunit.assertEquals(tsvreader:get_question("single_choice"), tsvreader.questions_table)
  luaunit.assertEquals(tsvreader:get_question("multiple_choice"), tsvreader.questions_table)
end

return TestTSVReader
