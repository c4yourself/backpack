local luaunit = require("luaunit")
local class = require("lib.classy")
local Memory = require("lib.memory.Memory")
local Profile = require("lib.profile.Profile")

local TestMemory = {}

-- Sets up test by creating a test object
function TestMemory:setUp()
  local pairs = 8
  self.profile = Profile("Lisa", "lisa@lisa.se", "04-08-1992", "female", "paris")
  self.profile:set_balance(0)
  self.profile:set_experience(0)
  local	memory = Memory(pairs, self.profile, false)
end

function TestMemory:test_is_finished()
  local state = "+1+1+2+2+3+3+4+45"
  local profile = Profile("Lisa", "lisa@lisa.se", "04-08-1992", "female", "paris")
	local memory = Memory.unserialize(state, profile)
  luaunit.assertEquals(memory:is_finished(), true)

  local state = "+1+1+2+2+3+3+4.45"
  local memory = Memory.unserialize(state, profile)
  luaunit.assertEquals(memory:is_finished(), false)

end

function TestMemory:test_look()
   local pairs = 8
	 local index = 1
   local memory = Memory(pairs, self.profile, false)
	 local card, is_open = memory:look(index)
  luaunit.assertEquals(card, index)
	luaunit.assertEquals(is_open, false)

	-- The card at the actual index is opened and if looking at the card it shall
  -- be open
	memory:open(index)
	local card, is_open = memory:look(index)
	luaunit.assertEquals(is_open, true)

	index = 4
	memory:open(index)
	local card, is_open = memory:look(index)

  -- One more open is made and both cards will now be facing upwards
	luaunit.assertEquals(is_open, true)

  memory:match()
  local card, is_open = memory:look(index)
  luaunit.assertEquals(is_open,false)
  index = 1
  local card, is_open = memory:look(index)
  luaunit.assertEquals(is_open,false)
end

function TestMemory:test_open()
  local pairs = 8
	local index = 1
  local	memory = Memory(pairs, self.profile, false)
	local no_of_moves = 0

	luaunit.assertEquals(memory:open(index), index)

	luaunit.assertErrorMsgContains("Card is already open", memory.open, memory, index)

  index = -1
  luaunit.assertErrorMsgContains("Index is out of bounds", memory.open, memory, index)

-- Since only one valid open attempt has been made, the	number of moves won't have changed
	luaunit.assertEquals(memory.moves, no_of_moves)

	index = 3;
	luaunit.assertEquals(memory:open(index), 2)

-- Now two successful opens has been made and and the number of moves will have incremented.
	luaunit.assertEquals(memory.moves, no_of_moves + 1)
  index = 4
  luaunit.assertErrorMsgContains("Cannot open three cards", memory.open, memory, index)

end

-- match is also tested in the test below
 function TestMemory:test_serialize()
  local pairs = 8
  local	memory = Memory(pairs, self.profile, false)

 	memory_string = memory:serialize();
  luaunit.assertEquals(memory_string, ".1.1.2.2.3.3.4.4.5.5.6.6.7.7.8.80")

 	memory:open(4)
 	memory_string = memory:serialize()
 	luaunit.assertEquals(memory_string, ".1.1.2+2.3.3.4.4.5.5.6.6.7.7.8.80")

 	memory:open(5)
 	memory_string = memory:serialize()
 	luaunit.assertEquals(memory_string, ".1.1.2+2+3.3.4.4.5.5.6.6.7.7.8.81")

  memory:match()
  memory_string = memory:serialize()
  luaunit.assertEquals(memory_string, ".1.1.2.2.3.3.4.4.5.5.6.6.7.7.8.81")

  memory:open(1)
  memory:open(2)
  memory:match()
  memory_string = memory:serialize()
  luaunit.assertEquals(memory_string, "+1+1.2.2.3.3.4.4.5.5.6.6.7.7.8.82")
end

function TestMemory:test_unserialize()
	state = ".1.1.2.2.3.3.4.45"
	local memory = Memory.unserialize(state)
  luaunit.assertEquals(memory.moves,5)
  index = 3
  local card, is_open = memory:look(index)
  luaunit.assertEquals(card, 2)
  luaunit.assertEquals(is_open, false)

  state = ".1.1.2.2.3+3.4.45"
	local memory = Memory.unserialize(state)
  index = 6
  local card, is_open = memory:look(index)
  luaunit.assertEquals(card, 3)
  luaunit.assertEquals(is_open, true)
end

function TestMemory:test_calculate_reward()
    local pairs = 8
    local	memory = Memory(pairs, self.profile, false)

    memory.moves = 8
    local coins, experience = memory:_calculate_reward()
    luaunit.assertEquals(coins, 120)

    memory.moves = 10
    local coins, experience = memory:_calculate_reward()
    luaunit.assertEquals(experience, 100)

    memory.moves = 16
    local coins, experience = memory:_calculate_reward()
    luaunit.assertEquals(experience, 20)
  end


return TestMemory
