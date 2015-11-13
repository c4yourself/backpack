local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Font = require("lib.font.Font")
local View = require("lib.view.View")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local SubSurface = require("lib.view.SubSurface")

local CityTourView = class("CityTourView", View)

function CityTourView:__init(remote_control)
	View.__init(self)
	--Create button colors
	-- local button_color = color(255, 99, 0, 255)
	-- local color_selected = color(255, 153, 0, 255)
	-- local color_disabled = color(111, 222, 111, 255) --have not been used yet
	self.attraction = {name = "The Eiffel Tower", pic_url = "data/images/CityTourEiffelTower.png"}

end


function CityTourView:render(surface)
	surface:clear({r=255, g=255, b=255, a=255})

	local height = surface:get_height()
	local width = surface:get_width()

	-- Create the picture
	surface:copyfrom(gfx.loadpng(utils.absolute_path(self.attraction.pic_url)) ,nil ,{ x = height/6, y = height/6, width = height*0.54*3/5, height = height*3/5})

	-- Create the fonts
	local city_tour_head_font = Font("data/fonts/DroidSans.ttf", 48, Color(0, 0, 0, 255))
	local city_tour_attraction_font = Font("data/fonts/DroidSans.ttf", 25, Color(0, 0, 0, 255))

	-- Draw the fonts
	city_tour_head_font:draw(surface, {x = height/6-10, y = 20}, "City Tour")
	city_tour_attraction_font:draw(surface, {x = height/6, y = height*23/30+5}, self.attraction.name)

end


return CityTourView
