---experiencecalculation
-- @classmod experiencecalculation
local class = require("lib.classy")
local utils = require("lib.utils")
local ExperienceCalculation = {}
--local event = require("lib.event")


---Calculate experience
-- @param counter representing a result from minigame
-- @game_type representing the type of game such as Connectfour, Memory, Multiplechoice and Mathquiz
-- @return experience_result representing the experience
function ExperienceCalculation.Calculation(counter,game_type)
	local experience_result = 0

	if game_type == "Multiplechoice" or game_type == "Mathquiz" then
		if counter >= 0 and counter <= 10 then
			if counter >=6 and counter <= 10 then
				experience_result = 50 + (counter - 6) * 5

				return experience_result
			else
				experience_result = 0

				return experience_result
			end
		else
			return false
		end
	elseif game_type == "Connectfour" then
		if counter > 0 and counter <= 10 then
			experience_result = 50

			return experience_result
		elseif counter > 10 and counter <= 20 then
			experience_result = 30

			return experience_result
		elseif counter > 20 then
			experience_result = 20

			return experience_result
		else
			return false
		end
	elseif game_type == "Memory" then
		if #counter == 2 then
			local index = counter[1] / (2 * counter[2])
			if index >= 2 then
				experience_result = 20

				return experience_result
			elseif index >= 1.8 and index <2 then
				experience_result = 40

				return experience_result
			elseif index >= 1.6 and index <1.8 then
				experience_result = 60

				return experience_result
			elseif index >= 1.4 and index < 1.6 then
				experience_result = 80

				return experience_result
			elseif index >= 1.2 and index < 1.4 then
				experience_result = 100

				return experience_result
			elseif index >= 1 and index < 1.2 then
				experience_result = 120

				return experience_result
			else
				return false
			end
		else
			return false
		end
	end
end

return ExperienceCalculation
