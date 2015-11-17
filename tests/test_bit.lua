local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local utils = require("lib.utils")


local bit = require("lib.bit")

local bor, band, bnand, rrotate, bxor, rshift, bnot =
bit.bor,  bit.band, bit.bnand, bit.rrotate, bit.bxor, bit.rshift, bit.bnot

local Testbit = {}


function Testbit:setUp()
end

function Testbit:test_band()
	luaunit.assertEquals(band(14,7),6)
end

function Testbit:test_bor()
	luaunit.assertEquals(bor(19,20,6),23)
end

function Testbit:test_lshift()
	luaunit.assertEquals(bnot(12,2),48)
end
return Testbit
