--- Color utility class
-- @classmod Color

local class = require("lib.classy")
local utils = require("lib.utils")

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

--- Blend this color with a given color.
-- Returns a new instance of the blended color.
-- @param color A color to blend with
-- @return A new Color instance
function Color:blend(color)
	return Color(
		(self.red + color.red) / 2,
		(self.green + color.green) / 2,
		(self.blue + color.blue) / 2,
		(self.alpha + color.alpha) / 2)
end

--- Convert color object to a 32-bit integer.
-- The bytes (8 bits) represent from low to high: red, green, blue and alpha.
-- @return 32-bit color
function Color:to_number()
	return bit32.bor(
		self.red,
		bit32.arshift(self.green, -8),
		bit32.arshift(self.blue, -16),
		bit32.arshift(self.alpha, -24))
end

--- Convert Color to a table that can be used with Zenterio's API functions.
-- If alpha channel is not the same as default it will be omitted.
function Color:to_table()
	return {self.red, self.green, self.blue, self.alpha}
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

--- Create color object from a 32-bit integer.
-- The bytes (8 bits) represent from low to high: red, green, blue and alpha.
-- @param color 32-bit integer
-- @return New Color instance
function Color.from_number(color)
	return Color(
		bit32.extract(color, 0, 8),
		bit32.extract(color, 1, 8),
		bit32.extract(color, 2, 8),
		bit32.extract(color, 3, 8))
end

--- Convert a table as expected by most Zenterio API functions to a Color
-- instance.
-- @param color A color table
function Color.from_table(color)
	-- Check that it is actually possible provided color is a table
	if type(color) ~= "table" and color == nil then
		error("Expected table or nil, got " .. type(color))
	end

	if color[1] ~= nil then
		return Color(color[1], color[2], color[3], color[4])
	elseif color.r ~= nil then
		return Color(color.r, color.g, color.b, color.a)
	elseif color.red ~= nil then
		return Color(color.red, color.green, color.blue, color.alpha)
	elseif color == nil or next(color) == nil then
		return Color()
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
