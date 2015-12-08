--- Drawing utility module
-- @module draw
local draw = {}

--- @{Color} class
draw.Color = require("lib.draw.Color")

--- @{Font} class
draw.Font = require("lib.draw.Font")

--- @{Rectangle} class
draw.Rectangle = require("lib.draw.Rectangle")

function draw.resize(surface, width, height)
	local output = gfx.new_surface(width, height)
	output:clear({0, 0, 0, 0})

	output:copyfrom(surface, nil, {width = width, height = height}, true)
	return output
end

draw.colors = {
	black = draw.Color(0, 0, 0, 255),
	white = draw.Color(255, 255, 255, 255),
	red = draw.Color(255, 0, 0, 255),
	green = draw.Color(0, 255, 0, 255),
	blue = draw.Color(0, 0, 255, 255),
}

return draw
