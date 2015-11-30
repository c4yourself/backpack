local bit = require("lib.bit")
local luaunit = require("luaunit")
local utils = require("lib.utils")

local TestBit = {}

local function b(value)
	return tonumber(value, 2)
end

function TestBit:test_band()
	luaunit.assertEquals(bit.band(
		b("11001"),
		b("10101")),
		b("10001"))

	local input = {
		a = b("11000011010010000010001100011101"),
		b = b("01001011110000100000100101010101"),
		c = b("11011011000001000000000100001001")
	}
	local output = b("01000011000000000000000100000001")

	luaunit.assertEquals(bit.band(input.a, input.b, input.c), output)
end

function TestBit:test_bor()
	luaunit.assertEquals(bit.bor(
		b("11001"),
		b("10101")),
		b("11101"))

	local input = {
		a = b("11000011010010000010001100011101"),
		b = b("01001011110000100000100101010101"),
		c = b("11011011000001000000000100001001")
	}
	local output = b("11011011110011100010101101011101")

	luaunit.assertEquals(bit.bor(input.a, input.b, input.c), output)
end

function TestBit:test_bxor()
	luaunit.assertEquals(bit.bxor(
		b("11001"),
		b("10101")),
		b("01100"))

	local input_a = b("11010010001010010110100011100011")
	local input_b = b("01010001001000001010101001011101")
	local output  = b("10000011000010011100001010111110")

	luaunit.assertEquals(bit.bxor(input_a, input_b), output)
end

function TestBit:test_bnot()
	local input  = b("11000000000000000000000110011001")
	local output = b("00111111111111111111111001100110")
	luaunit.assertEquals(bit.bnot(input), output)
end

function TestBit:test_lshift()
	luaunit.assertEquals(bit.lshift(b("11001"), 2), b("1100100"))
end

function TestBit:test_rshift()
	luaunit.assertEquals(bit.rshift(b("11001"), 2), b("110"))
end

function TestBit:test_lrotate()
	local input  = b("11000000000000000000000000011000")
	local output = b("00000000000000000000000001100011")
	luaunit.assertEquals(bit.lrotate(input, 2), output)
end

function TestBit:test_rrotate()
	local input  = b("11000000000000000000000000011000")
	local output = b("00110000000000000000000000000110")
	luaunit.assertEquals(bit.rrotate(input, 2), output)
end

return TestBit
