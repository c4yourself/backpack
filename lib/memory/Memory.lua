
local class = require("lib.classy")
local Memory = class("Memory")

--- Constructor for Memory
-- @param paris is an integer
-- @param scrambled is false, then the pairs should be {1,1,2,2,etc.}
function Memory:__init(pairs, scrambled)
	if scrambled == false then
		self.scrambled = false
 	else
		self.scrambled = true
	end
	self.pairs = pairs
	self.cards = _create_pairs()
	self.moves = 0
	self.state = {}

	for i = 1, pairs do
		table.insert(self.state, false)
		table.insert(self.state, false)
	end

	-- if (scrambled ~= nil) {
	-- 	self.scrambled = scrambled
	-- } else {
	-- 	self.scrambled = true
	-- }
	-- self.pairs = pairs
end

--- Generates pairs for the board
-- @return a is table of pairs for the memory
-- @local
function Memory:_create_pairs()
--Provide a better name for a?
	local	a = {}
	if self.scrambled == false then
		for i = 1, self.pairs do
			table.insert(a,i)
			table.insert(a,i)
		end
	else
		for i = 1, self.pairs do
			local d = math.random(self.pairs)
			table.insert(a,d)
			table.insert(a,d)
		end
	end
	return a
end


function Memory:look(index)

end

function Memory:open(index)
	if index > table.getn(state) then
		error("Index is greater than number of cards")
	elseif state(index) == true then
		error("Card is already open")
	else
		state[index] = true
		self.moves = self.moves + 1
		return cards[index]
	end

function Memory:is_finished()

end

function Memory:serialize(columns)
end


end
