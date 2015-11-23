
local class = require("lib.classy")
local utils = require("lib.utils")
local ExperienceCalculation = class("experiencecalculation")
local event = require("lib.event")

ExperienceCalculation.game_type = ""
ExperienceCalculation.counter = {}

function ExperienceCalculation:Calculation(counter,game_type)
	if game_type == "Multiplechoice" or game_type == "Mathquiz" then
		if counter >= 0 and counter <= 10 then
			if counter >=6 and counter <= 10 then
				return 50 + (counter - 6) * 5
			else
				return 0
			end
		else
		end
	elseif game_type == "Connectfour" then
		if #counter == 1 then
			if counter > 0 and counter <= 10 then
				return 50
			elseif counter > 0 and counter <= 10 then
				return 30
			else
				return 20
			end
		else
			return false
		end
	elseif game_type == "Memory" then
		if #counter == 2 then
			if counter[1] / (2 * counter[2]) >=2 then
				return 20
			end
			if counter[1] / (2 * counter[2]) >=1.8 then
				return 40
			end
			if counter[1] / (2 * counter[2]) >=1.6 then
				return 60
			end
			if counter[1] / (2 * counter[2]) >=1.4 then
				return 80
			end
			if counter[1] / (2 * counter[2]) >=1.2 then
				return 100
			end
			if counter[1] / (2 * counter[2]) >=1 then
				return 120
			end
		else
			return false
		end
	end
end
