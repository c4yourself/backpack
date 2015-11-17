
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
	self.first_card = nil
	self.second_card = nil


	for i = 1, pairs do
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
	local card
	local state
	if index > #self.state or index <= 0 then
		error("Index is out of bounds")
	else
		card = self.cards[index]
		state = self.state[index]
	end
	return card, state
end

function Memory:open(index)
-- Raise an error if index is out of bounds
-- of if card is already open
	local length = #self.state
	local card, is_open = self:look(index)
	if is_open == true then
		error("Card is already open")
	else
		if self.first_card == nil then
			self.first_card = index
			self.state[index] = true
		elseif self.second_card == nil then
			self.second_card = index
			self.state[index] = true
		else
			error("Cannot open three cards")
		end
		self.open_counter = self.open_counter + 1
		self.moves = math.floor(self.open_counter / 2)
		return self.cards[index]
	end
end


function Memory:match()
	if self.cards[self.first_card] ~= self.cards[self.second_card] then
		self.state[self.first_card] = false
		self.state[self.second_card] = false
		self.first_card = nil
		self.second_card = nil
		return false
	end
	self.first_card = nil
	self.second_card = nil
	return true
end

function Memory:is_finished()
	local is_finished = false

	for i = 1, #self.state do
		if self.state[i] == false then
			is_finished = false
			break
		else
			is_finished = true
		end
	end
	return is_finished
end

function Memory:serialize(columns)
	local string_serialize = ""
	local length = #self.state
--	local state_val = "."

	for i = 1, length do
		local state_val = "."

		if self.state[i] == true then
		 	 state_val = "+"
	 	end
	 	string_serialize = string_serialize .. state_val .. self.cards[i]
	end
	string_serialize = string_serialize .. self.moves

	return string_serialize
end

function Memory.unserialize(new_state)
	local length = string.len(new_state)
	local no_of_pairs = (length - 1) / 4
	local memory = Memory(no_of_pairs)
	local state = {}
	local cards = {}
	local moves = 0

	for i = 1,string.len(new_state) do
		local char = new_state:sub(i,i)
		if char == "." then
			table.insert(state,false)
		elseif char == "+" then
			table.insert(state,true)
		elseif i == string.len(new_state) then
			moves = tonumber(tonumber(char))
		else
			table.insert(cards, tonumber(char))
		end
		memory.state = state
		memory.cards = cards
		memory.moves = moves
		memory.open_counter = moves * 2
	end
	return memory
end

return Memory
