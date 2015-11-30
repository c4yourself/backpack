--- Bitwise operators for platforms where they are not supported. This module
-- mimics parts of Lua 5.2's default bit32 module.
-- @module bit
local bit = {}

local function bnand(x, y, z)
	local z = z or 2 ^ 16
	if z < 2 then
		return 1 - x * y
	else
		return
			bnand(
				(x - x % z) / z,
				(y - y % z) / z,
				math.sqrt(z)) * z +
			bnand(x % z, y % z, math.sqrt(z))
	end
end

local function bor(x, y, z)
	return bnand(bit.bnot(x, z), bit.bnot(y, z), z)
end

local function band(x, y, z)
	return bnand(bit.bnot(0, z), bnand(x, y, z), z)
end

local function bxor(x, y)
	if true then return bit32.bxor(x, y) end
	local _x, _y = x, y
	local z = 0
	for i = 0, 31 do
		if (x % 2 == 0) then                      -- x had a '0' in bit i
			 if ( y % 2 == 1) then                  -- y had a '1' in bit i
					y = y - 1
					z = z + 2 ^ i                       -- set bit i of z to '1'
			 end
		else                                      -- x had a '1' in bit i
			 x = x - 1
			 if (y % 2 == 0) then                  -- y had a '0' in bit i
					z = z + 2 ^ i                       -- set bit i of z to '1'
			 else
					y = y - 1
			 end
		end
		y = y / 2
		x = x / 2
	end

	return z
end

--- Bitwise negation of value
-- @param value Value to be negated
-- @return Negation of value
function bit.bnot(value)
	return (-1 - value) % 2 ^ 32
end

--- Bitwise and of all arguments.
-- @param ... One or more 32-bit integers
-- @return Bitwise and of all arguments
function bit.band(a, ...)
	local values = {...}
	local out = a % 2 ^ 32

	for i, value in ipairs(values) do
		out = band(out % 2 ^ 32, value % 2 ^ 32)
	end

	return out
end

--- Bitwise or of all arguments.
-- @param ... One or more 32-bit integers
-- @return Bitwise or of all arguments
function bit.bor(a, ...)
	local values = {...}
	local out = a % 2 ^ 32

	for i, value in ipairs(values) do
		out = bor(out % 2 ^ 32, value % 2 ^ 32)
	end

	if out ~= bit32.bor(a, ...) then
		print("error or")
	end

	return out
end

--- Bitwise xor of all arguments.
-- @param ... One or more 32-bit integers
-- @return Bitwise xor of all arguments
function bit.bxor(a, ...)
	local values = {...}
	local out = a % 2 ^ 32

	for i, value in ipairs(values) do
		out = bxor(out % 2 ^ 32, value % 2 ^ 32)
	end

	return out
end

--- Shift bits to the left.
-- @param value Integer to be shifted
-- @param bits Number of bits to shift by
-- @return Left shifted value
function bit.lshift(value, bits)
	if bits < 0 then
		return bit.rshift(value, -bits)
	end

	return (value * 2 ^ bits) % 2 ^ 32
end

--- Shift bits to the right.
-- @param value Integer to be shifted
-- @param bits Number of bits to shift by
-- @return Right shifted value
function bit.rshift(value, bits)
	if bits < 0 then
		return bit.lshift(value, -bits)
	end

	return math.floor(value % 2 ^ 32 / 2 ^ bits)
end

--- Returns the unsigned number formed by the bits field to field + width - 1
-- from n. Bits are numbered from 0 (least significant) to 31 (most significant).
-- All accessed bits must be in the range [0, 31].
--
-- @param value Value to extract from
-- @param field Index to extract bits from
-- @param[opt] width Width in bits for every field. Default is 1.
-- @return Unsigned integer in the given field
function bit.extract(value, field, width)
	local mask = 0
	for i = 0, width - 1 do
		mask = bit.bor(mask, bit.lshift(1, i))
	end

	return bit.band(mask, bit.rshift(value, field * width))
end

--- Rotate bits to the left.
-- @param value Integer to be rotated
-- @param bits Number of bits to rotate by
-- @return Left rotated value
function bit.lrotate(value, bits)
	return bit.bor(bit.lshift(value, bits), bit.rshift(value, 32 - bits))
end

--- Rotate bits to the right.
-- @param value Integer to be rotated
-- @param bits Number of bits to rotate by
-- @return Right rotated value
function bit.rrotate(value, bits)
	return bit.bor(bit.rshift(value, bits), bit.lshift(value, 32 - bits))
end

return bit
