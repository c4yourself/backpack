--- Color utility class
-- @classmod Color

local class = require("lib.classy")
local utils = require("lib.utils")

local bitlib = require("lib.bit")

function bit_extract(value, field, width)
	if bit32 == nil then
		return tonumber(
			utils.to_base(value, 2):reverse():sub(
				field * width, (field + 1) * width):reverse(),
			2)
	else
		return bit32.extract(value, field, width)
	end
end


local Color = class("Color")

Color.default_red = 0
Color.default_green = 0
Color.default_blue = 0
Color.default_alpha = 255

--- Constructor for Color.
-- @param red Amount of red (0-255)
-- @param green Amount of green (0-255)
-- @param blue Amount of blue (0-255)
-- @param alpha Amount of alpha (0-255)
function Color:__init(red, green, blue, alpha)
	self.red = red or self.default_red
	self.green = green or self.default_green
	self.blue = blue or self.default_blue
	self.alpha = alpha or self.default_alpha
end

function Color:__eq(other)
	if not class.is_a(other, Color) then
		error("Color must be compared to another Color instance")
	end

	return
		self.red == other.red and
		self.green == other.green and
		self.blue == other.blue and
		self.alpha == other.alpha
end

--- Blend this color with a given color.
-- Returns a new instance of the blended color.
-- @param other A color to blend with
-- @return A new Color instance
function Color:blend(other)
	-- Convert colors to ratios between 0 and 1
	local sr, sg, sb, sa =
		self.red / 255, self.green / 255, self.blue / 255, self.alpha / 255
	local or_, og, ob, oa =
		other.red / 255, other.green / 255, other.blue / 255, other.alpha / 255

	local output_alpha = oa + sa * (1 - oa)
	local output_red = (or_ * oa + sr * sa * (1 - oa)) / output_alpha
	local output_green = (og * oa + sg * sa * (1 - oa)) / output_alpha
	local output_blue = (ob * oa + sb * sa * (1 - oa)) / output_alpha

	return Color(
		255 * output_red,
		255 * output_green,
		255 * output_blue,
		255 * output_alpha)
end

--- Convert color object to a 32-bit integer.
-- The bytes (8 bits) represent from low to high: red, green, blue and alpha.
-- @return 32-bit color
function Color:to_number()
	return bitlib.bor(
		self.red,
		bitlib.lshift(self.green, 8),
		bitlib.lshift(self.blue, 16),
		bitlib.lshift(self.alpha, 24))
end

--- Convert Color to a HTML style color string.
-- Format is `#RRGGBBAA`, `AA` is omitted if alpha channel is the same as default.
-- @return HTML style color string
function Color:to_html()
	local output = string.format(
		"#%2s%2s%2s",
		utils.to_base(self.red, 16),
		utils.to_base(self.green, 16),
		utils.to_base(self.blue, 16))

	-- Don't add alpha if it is opaque
	if self.alpha ~= self.default_alpha then
		output = output .. string.format("%2s", utils.to_base(self.alpha, 16))
	end

	-- Since 0 padding is only supported for numbers we use spaces and replace
	-- them with zeroes here
	return output:gsub(" ", "0")
end

--- Convert Color to a table that can be used with Zenterio's API functions.
-- If alpha channel is not the same as default it will be omitted.
function Color:to_table()
	return {self.red, self.green, self.blue, self.alpha}
end

--- Return red, green blue and alpha as separate values.
-- @return red, gree, blue, alpha
function Color:to_values()
	return self.red, self.green, self.blue, self.alpha
end

--- Create color object from a 32-bit integer.
-- The bytes (8 bits) represent from low to high: red, green, blue and alpha.
-- @param color 32-bit integer
-- @return New Color instance
function Color.from_number(color)
	return Color(
		bitlib.extract(color, 0, 8),
		bitlib.extract(color, 1, 8),
		bitlib.extract(color, 2, 8),
		bitlib.extract(color, 3, 8))
end

--- Convert a table as expected by most Zenterio API functions to a Color
-- instance.
-- @param color A color table
function Color.from_table(color)
	-- Check that it is actually possible provided color is a table
	if type(color) ~= "table" and color ~= nil then
		error("Expected table or nil, got " .. type(color))
	end

	if color == nil or next(color) == nil then
		return Color()
	elseif color[1] ~= nil then
		return Color(color[1], color[2], color[3], color[4])
	elseif color.r ~= nil then
		return Color(color.r, color.g, color.b, color.a)
	elseif color.red ~= nil then
		return Color(color.red, color.green, color.blue, color.alpha)
	else
		error("Invalid color table format")
	end
end

--- Create Color object from a HTML style string.
-- The string may be prefixed with # followed by color format:
--
-- - `#RGB`
-- - `#RGBA`
-- - `#RRGGBB`
-- - `#RRGGBBAA`
-- @param string HTML style color code
-- @return New Color instance
function Color.from_html(string)
	-- Validate input and remove leading # if provided
	hex = string.match(string, "^#?([A-Fa-f0-9]+)$")
	if hex == nil or #hex < 3 or #hex > 8 or #hex == 5 or #hex == 7 then
		error("Invalid hex format provided")
	end

	-- Expand length if shorthands are provided
	if #hex == 3 or #hex == 4 then
		hex = (
			hex:sub(1, 1) .. hex:sub(1, 1) ..
			hex:sub(2, 2) .. hex:sub(2, 2) ..
			hex:sub(3, 3) .. hex:sub(3, 3) ..
			hex:sub(4, 4) .. hex:sub(4, 4))
	end

	-- Add default alpha value if provided
	if #hex == 6 then
		hex = hex .. utils.to_base(Color.default_alpha, 16)
	end

	return Color.from_number(tonumber(hex, 16))
end

return Color
