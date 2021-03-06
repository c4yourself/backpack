--- Color utility class
-- @classmod Color

local class = require("lib.classy")
local utils = require("lib.utils")

local bitlib = require("lib.bit")

local function is_integer(number)
	return number == math.floor(number)
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
	-- Perform sanity checks for all given values. This is done before merging
	-- with default values to prevent boolean false from being accepted as nil
	if red ~= nil and type(red) ~= "number" then
		error("Invalid format for red, expected number or nil got " .. type(red))
	end

	if green ~= nil and type(green) ~= "number" then
		error("Invalid format for green, expected number or nil got " .. type(green))
	end

	if blue ~= nil and type(blue) ~= "number" then
		error("Invalid format for blue, expected number or nil got " .. type(blue))
	end

	if alpha ~= nil and type(alpha) ~= "number" then
		error("Invalid format for alpha, expected number or nil got " .. type(alpha))
	end

	-- Add default values
	red = red or self.default_red
	green = green or self.default_green
	blue = blue or self.default_blue
	alpha = alpha or self.default_alpha

	-- Verify that provided colors are with range and integers
	if red < 0 or red > 255 or not is_integer(red) then
		error("Red is not an integer between 0 and 255")
	end

	if green < 0 or green > 255 or not is_integer(green) then
		error("Red is not an integer between 0 and 255")
	end

	if blue < 0 or blue > 255 or not is_integer(blue) then
		error("Blue is not an integer between 0 and 255")
	end

	if alpha < 0 or alpha > 255 or not is_integer(alpha) then
		error("Alpha is not an integer between 0 and 255")
	end

	-- Add colors to self after validation to prevent being in an invalid state
	self.red = red
	self.green = green
	self.blue = blue
	self.alpha = alpha

end

function Color:__tostring()
	return string.format("<%s %s>", class.name(self), self:to_html())
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

function Color:__lt(other)
	if not class.is_a(other, Color) then
		error("Color must be compared to another Color instance")
	end

	-- Convert colors to ratios between 0 and 1
	local sr, sg, sb, sa = self:to_values(1)
	local or_, og, ob, oa = other:to_values(1)

	-- Multiply every color with the alpha transparency to compare them properly
	sr = sr * sa
	sg = sg * sa
	sb = sb * sa

	or_ = or_ * oa
	og = og * oa
	ob = ob * oa

	return sr < or_ and sg < og and sb < ob
end


--- Blend this color with a given color.
-- Returns a new instance of the blended color.
-- @param other A color to blend with
-- @return A new Color instance
function Color:blend(other)
	-- Convert colors to ratios between 0 and 1
	local sr, sg, sb, sa = self:to_values(1)
	local or_, og, ob, oa = other:to_values(1)

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

function Color:replace(red, green, blue, alpha)
	if type(red) == "table" then
		local color = red
		red = color.red or color.r
		green = color.green or color.g
		blue = color.blue or color.b
		alpha = color.alpha or color.a
	end

	return Color(
		red or self.red,
		green or self.green,
		blue or self.blue,
		alpha or self.alpha)
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
-- @param format Format of returned table. May be either `index`, `short` or `long`
-- @return Table representation of Color
function Color:to_table(format)
	if format == nil or format == "index" then
		return {self.red, self.green, self.blue, self.alpha}
	elseif format == "short" then
		return {r = self.red, g = self.green, b = self.blue, a = self.alpha}
	elseif format == "long" then
		return {
			red = self.red,
			green = self.green,
			blue = self.blue,
			alpha = self.alpha
		}
	else
		error("Invalid format '" .. format .. "', expected index, short or long")
	end
end

--- Return red, green blue and alpha as separate values.
-- @return red, gree, blue, alpha
function Color:to_values(normalize)
	if normalize == nil then
		normalize = 255
	end

	return
		self.red * normalize / 255,
		self.green * normalize / 255,
		self.blue * normalize / 255,
		self.alpha * normalize / 255
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

	-- Check that color is not a Color instance, since this will not work on the
	-- set-top box.
	if class.is_a(color, Color) then
		error(
			"Provided color is a Color instance. This is not a valid table " ..
			"format, use :to_table() to convert it.")
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
