
local class = require("lib.classy")
local Question = require("lib.memory.Memory")


--- Constructor for Memory
-- @param image_path path to the image as a string
-- @param question string representing a mathematical expression
-- @param correct_answer number representing the correct answer
function Memory:__init(pairs, scrambled)
	if (scrambled != nil) {
		self.scrambled = scrambled
	} else {
		self.scrambled = true
	}
	self.pairs = pairs
end
