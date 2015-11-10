
local class = require("lib.classy")
local serpent = require("lib.serpent")
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
	self.cards = self:_create_pairs()
	self.moves = 0
	self.open_counter = 0
	self.state = {}


	for i = 1, 8 do
		table.insert(self.state, false)
		table.insert(self.state, false)
	end
end

--- Generates pairs for the board
-- @return a is table of pairs for the memory
-- @local
function Memory:_create_pairs()
--Provide a better name for a?
	local	temp_table = {}
	for i = 1, self.pairs do
		table.insert(temp_table,i)
		table.insert(temp_table,i)
	end
	--print(serpent.line(temp_table))

	if self.scrambled == true then
		for i = 1, self.pairs*2 do
			local switch_index_1 = math.random(#temp_table)
			local switch_index_2 = math.random(#temp_table)
			local switch_val_1 = temp_table[switch_index_1]
			local switch_val_2 = temp_table[switch_index_2]
			temp_table[switch_index_1] = switch_val_2
			temp_table[switch_index_2] = switch_val_1
		end
	end
	return temp_table
end


function Memory:look(index)
	if index > #self.state then
		error("Index is greater than number of cards")
	else
		local card = self.cards[index]
		local state = self.state[index]
	end
	print(state)
	return card, state
end

function Memory:open(index)
-- Raise an error if index is out of bounds
-- of if card is already open

	if index > #self.state or index <= 0 then
--		print("Index error")
		error("Index is greater than number of cards")
	elseif self.state[index] == true then
		error("Card is already open")
	else
		self.open_counter = self.open_counter + 1
		self.moves = math.floor(self.open_counter / 2)
--		print("moves: "..self.moves)
		if self.open_counter % 2 ~= 0 then
					self.state[index] = true
		else
			for i = 1, #self.cards do
				if (self.cards[i] == self.cards[index]) and (i ~= index) then
					if self.state[i] == true then
						self.state[index] = true
					end
				end
			end
		end
		return self.cards[index]
	end
end

function Memory:is_finished()
	local is_finished = false
	for i = 1, #self.state do
		if self.state[i] == false then break
		else
			is_finished = true
		end
	end
	return is_finished
end

function Memory:serialize(columns)
	local string_serialize = ""
	local length = #self.state
	local state_val = "."

	for i = 1, length do
		if self.state[i] == true then
		 	 state_val = "+"
--	 	else
--		 	local state_val = "."
	 	end
	 	local string_serialize = string_serialize .. state_val .. self.cards[i]
		print("String seri: " .. string_serialize)
	end
	print("String seri2: " .. string_serialize)

	string_serialize = string_serialize .. self.moves
	print("String seri3: " .. string_serialize)

	return string_serialize
end

function Memory.unserialize(new_state)
	local length = string.len(new_state)
	local no_of_pairs = (length - 1) / 4
	local memory = Memory(no_of_pairs)
	local state = {}
	local cards = {}
	local moves = {}

	for i = 1,string.len(new_state) do
		if new_state[i] == "." then
			table.insert(state,false)
		elseif new_state[i] == "+" then
			table.insert(state,true)
		elseif i == string.len(new_state) then
			moves = new_state[i]
		else
			table.insert(cards, new_state[i])
		end
		memory.state = state
		memory.cards = cards
		memory.moves = moves
		memory.open_counter = moves * 2
	end
	return memory
end

return Memory
