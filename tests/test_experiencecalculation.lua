local luaunit = require("luaunit")
local class = require("lib.classy")
local utils = require("lib.utils")
local ExperienceCalculation = require("lib.scores.experiencecalculation")
local TestExperienceCalculation = {}

function TestExperienceCalculation:test_Calculation()
	luaunit.assertEquals(ExperienceCalculation.Calculation(5, "Multiplechoice"), 0)
	luaunit.assertEquals(ExperienceCalculation.Calculation(6, "Multiplechoice"), 50)
	luaunit.assertEquals(ExperienceCalculation.Calculation(10, "Multiplechoice"), 70)
	luaunit.assertEquals(ExperienceCalculation.Calculation(-1, "Multiplechoice"), false)
	luaunit.assertEquals(ExperienceCalculation.Calculation(5, "Mathquiz"), 0)
	luaunit.assertEquals(ExperienceCalculation.Calculation(6, "Mathquiz"), 50)
	luaunit.assertEquals(ExperienceCalculation.Calculation(10, "Mathquiz"), 70)
	luaunit.assertEquals(ExperienceCalculation.Calculation(-1, "Mathquiz"), false)
	luaunit.assertEquals(ExperienceCalculation.Calculation({20,5}, "Memory"), 20)
	luaunit.assertEquals(ExperienceCalculation.Calculation({18,5}, "Memory"), 40)
	luaunit.assertEquals(ExperienceCalculation.Calculation({16,5}, "Memory"), 60)
	luaunit.assertEquals(ExperienceCalculation.Calculation({14,5}, "Memory"), 80)
	luaunit.assertEquals(ExperienceCalculation.Calculation({12,5}, "Memory"), 100)
	luaunit.assertEquals(ExperienceCalculation.Calculation({10,5}, "Memory"), 120)
	luaunit.assertEquals(ExperienceCalculation.Calculation({5,10}, "Memory"), false)
	luaunit.assertEquals(ExperienceCalculation.Calculation(5, "Connectfour"), 50)
	luaunit.assertEquals(ExperienceCalculation.Calculation(11, "Connectfour"), 30)
	luaunit.assertEquals(ExperienceCalculation.Calculation(30, "Connectfour"), 20)
	luaunit.assertEquals(ExperienceCalculation.Calculation(-1, "Connectfour"), false)
end

return TestExperienceCalculation
