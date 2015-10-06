local utils = require("lib.utils")
local menu = {}

function menu.render(surface)
	local backgroundColor = {r=0, g=0, b=0}
	surface:clear(backgroundColor)

	local buttonColor = {r=255, g=255, b=255}
	local textColor = {r=155, g=100, b=255}
	local textButton1 = sys.new_freetype(textColor, 20, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local textButton2 = sys.new_freetype(textColor, 20, {x=200,y=280}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local textButton3 = sys.new_freetype(textColor, 20, {x=200,y=480}, utils.absolute_path("data/fonts/DroidSans.ttf"))

	surface:fill(buttonColor, {width=500, height=100, x=100, y=50})
	textButton1:draw_over_surface(surface, "1. Numerical quiz")

	surface:fill(buttonColor, {width=500, height=100, x=100, y=250})
	textButton2:draw_over_surface(surface, "2. Multiple choice question")

	surface:fill(buttonColor, {width=500, height=100, x=100, y=450})
	textButton3:draw_over_surface(surface, "3. Exit")

end

return menu
