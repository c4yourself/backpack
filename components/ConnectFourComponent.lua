local class = require("lib.classy")
local ConnectFour = require("lib.connectfour.ConnectFour")
local event = require("lib.event")
local View = require("lib.view.View")
local utils = require("lib.utils")

local ConnectFourComponent = class("ConnectFourComponent", View)

function ConnectFourComponent:__init(remote_control)
	View.__init(self)

	if remote_control ~= nil then
		self.event_listener = remote_control
	else
		self.event_listener = event.remote_control
	end

end


function ConnectFourComponent:render(surface)
	width_coinbox = (1/7)*(0.45)*surface:get_width()
	height_coinbox = (1/7)*(0.8)*surface:get_height()
	--surface:clear({r=255, g=255, b=255}, {x=10, y=10, width = surface:get_width()*0.5, height = surface:get_height()*0.5})
	surface:clear({r=255, g=255, b=255}, {x=10, y=10, width = width_coinbox, height = height_coinbox})
	surface:clear({r=255, g=255, b=255}, {x=100, y=100, width = width_coinbox, height = height_coinbox})


	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}

	local text_color = {r=0, g=0, b=0}
	local game_title = sys.new_freetype(textColor, 30, {x=100,y=400}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local choiceButton2 = sys.new_freetype(textColor, 30, {x=350,y=400}, utils.absolute_path("data/fonts/DroidSans.ttf"))

	--box = sys.new_freetype(
	--{r = 0, g = 0, b = 0, a = 255},
	--coin_color_computer,
	--72,
	--{x = 300, y = 300},
	--utils.absolute_path("data/fonts/DroidSans.ttf"))
	--box:draw_over_surface(surface, surface:get_width() .. "x" .. surface:get_height())

end

return ConnectFourComponent
