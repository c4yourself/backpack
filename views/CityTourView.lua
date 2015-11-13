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
end


function CityTourView:render(surface)
	surface:clear({r=255, g=255, b=255, a=255})
	local height = surface:get_height()
	local width = surface:get_width()

	--local city_tour_head = sys.new_freetype(status_text_color, 25, {x=10, y=10}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	--city_tour_head:draw_over_surface(surface, "City Tour")

end


return CityTourView
