local luaunit = require("luaunit")

-- Prevent bit32 from being used since it is not available in emulator. Falls
-- back on lib.bit
local _bit32 = bit32
bit32 = nil
local hash = require("lib.hash")
bit32 = _bit32

local TestHash = {}

function TestHash:test_sha256()
	luaunit.assertEquals(
		hash.hash256("test"),
		"9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08")
end

return TestHash
