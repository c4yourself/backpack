local class = require("lib.classy")
local PlayerMock = require("lib.mocks.PlayerMock")
local luaunit = require("luaunit")

local TestPlayerMock = {}

-- tests the state
function TestPlayerMock:test_state()
	PlayerMock.play_url(url)
	luaunit.assertEquals(PlayerMock:get_state(), 4)
	--luaunit.assertEquals(PlayerMock.get_state(), 4)
	PlayerMock.stop(url)
	luaunit.assertEquals(PlayerMock:get_state(), 0)
end

-- tests the set-functions
function TestPlayerMock:test_set_functions()
	PlayerMock:set_player_window(1, 2, 3, 4, 5, 6)
	PlayerMock:set_on_eos_pseudocallback(callback)
	PlayerMock:set_aspect_ratio(aspect_ratio)
end

return TestPlayerMock
