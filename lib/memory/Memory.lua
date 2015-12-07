
local class = require("lib.classy")
local serpent = require("lib.serpent")
local Memory = class("Memory")
local Profile = require("lib.profile.Profile")

--- Constructor for Memory
-- @param pairs is an number describing the number of pairs
-- @param profile is the profile playing
-- @param scrambled is false, then the pairs should be {1,1,2,2,etc.}
function Memory:__init(pairs, profile, scrambled)
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
	self.finished = false
	self.profile = profile
	self.found_pairs = 0

	for i = 1, self.pairs do
		table.insert(self.state, false)
		table.insert(self.state, false)
	end
end

--- Generates pairs for the board
-- @return temp_table is a is table of pairs for the memory
function Memory:_create_pairs()
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

--- Peek at a card at index
-- @param index is the number where to look
-- @return card is the card peeked at
-- @return state is whether the card is opened or not
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

--- Opens the card at index
-- @param index in the number of the card to open
-- @return card at index provided
function Memory:open(index)
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

--- Match checks if two cards are matching
function Memory:match()
	if self.state[self.second_card] ~= nil then
		if self.cards[self.first_card] ~= self.cards[self.second_card] then
			self.state[self.first_card] = false
			self.state[self.second_card] = false
		else
			self.found_pairs = self.found_pairs + 1
		end
		self.first_card = nil
		self.second_card = nil
	end
end

--- Will check if all pairs are found
-- @return boolean true or false
function Memory:is_finished()
	local count = 0
	for i = 1, #self.state do
		if self.state[i] == false then
			self.finished = false
			break
		elseif self.state[i] == true then
			count = count + 1
				if count == #self.state then
					self.finished = true
				end
		end
	end
	return self.finished
end

--- Will convert the board and state into a string representation
-- @param columns is the number of columns in current game
-- @return string_serialize is the string representation of the game
function Memory:serialize(columns)
	local string_serialize = ""
	local length = #self.state

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

--- Will do the reverse of serialize and convert the string representation
-- into a board and state
-- @param new_state is the serialized version
-- @param profile is the profile playing
-- @return is a memory instance
function Memory.unserialize(new_state, profile)
	local length = string.len(new_state)
	local no_of_pairs = (length - 1) / 4
	local memory = Memory(no_of_pairs, profile)
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
