local ColorButton = require("components.ColorButton")
local draw = require("lib.draw")
local SurfaceButton = require("components.SurfaceButton")
local TextButton = require("components.TextButton")

local style =  {}

style.colors = {
	-- Generic button colors
	button = draw.Color(255, 99, 0, 255),
	button_selected = draw.Color(255, 153, 0, 255),
	button_disabled = draw.Color(111, 222, 111, 255)
}

style.fonts = {
	button_text = draw.Font("data/fonts/DroidSans.ttf", 25, draw.colors.white)
}

function style.color_button()
	return ColorButton(
		style.colors.button,
		style.colors.button_selected,
		style.colors.button_disabled)
end

function style.text_button(text)
	return TextButton(
		text,
		style.fonts.button_text,
		style.colors.button,
		style.colors.button_selected,
		style.colors.button_disabled)
end

function style.surface_button(surface)
	return SurfaceButton(
		surface,
		style.colors.button,
		style.colors.button_selected,
		style.colors.button_disabled)
end

return style
