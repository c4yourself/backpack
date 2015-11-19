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


function bit.bnot(y, z)
	return bnand(bnand(0, 0, z), y, z)
end

function bit.band(a, ...)
	local values = {...}
	local out = a

	for i, value in ipairs(values) do
		out = band(out, value)
	end

	return out
end

function bit.bor(a, ...)
	local values = {...}
	local out = a

	for i, value in ipairs(values) do
		out = bor(out, value)
	end

	return out
end

function bit.lshift(value, bits)
	if bits < 0 then
		return bit.rshift(value, -bits)
	end

	return value * 2 ^ bits
end

function bit.rshift(value, bits)
	if bits < 0 then
		return bit.lshift(value, -bits)
	end

	return math.floor(value % 2 ^ 32 / 2 ^ bits)
end

function bit.extract(value, field, width)
	local mask = 0
	for i = 0, width - 1 do
		mask = bit.bor(mask, bit.lshift(1, i))
	end

	return bit.band(mask, bit.rshift(value, field * width))
end

function bit.rrotate(value, bits)
	result = bit.bor(bit.rshift(value, bits),bit.lshift(value, 32-bits))
	return result
end

function bit.lrotate(value, bits)
	result = bit.bor(bit.lshift(value, bits), bit.rshift(value, 32-bits))
 	return result
end

function bit.bxor(x, y)
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

return bit
