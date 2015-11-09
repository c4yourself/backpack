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
	surface:clear({r=255, g=255, b=255}, {x=10, y=surface:get_height()-height_coinbox, width = width_coinbox, height = height_coinbox})
	--surface:clear({r=255, g=255, b=255}, {x=100, y=100, width = width_coinbox, height = height_coinbox})

	local posy = 0.1*surface:get_height()
	local tempcolor = 255

	for i = 1, 7 do
		local posx = 0.35*surface:get_width()
        for j = 1, 7 do
          surface:clear({r=tempcolor, g=tempcolor, b=tempcolor}, {x=posx, y=posy, width = width_coinbox, height = height_coinbox})
					posx = posx + width_coinbox
					tempcolor = tempcolor - 5
        end

				posy = posy + height_coinbox
    end

	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}

surface:fill({r=255, g=255, b=255}, {width=200, height=60, x=0.05*surface:get_width(),y=0.9*surface:get_height()-1.5*height_coinbox})
	local choiceButton = sys.new_freetype({r = 255, g = 128, b = 0, a = 255}, 22,
	{x=0.05*surface:get_width(),y=0.9*surface:get_height()-1.5*height_coinbox}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	choiceButton:draw_over_surface(surface,"Back to the city")


	local heading = sys.new_freetype({r = 255, g = 128, b = 0, a = 255}, 36,
	{x = 0.05 * surface:get_width() , y = 0.1 * surface:get_height() },
	utils.absolute_path("data/fonts/DroidSans.ttf"))
	heading:draw_over_surface(surface, "Connect Four")

	local text_player = sys.new_freetype(coin_color_player, 22,
	{x = 0.05 * surface:get_width() , y = 0.5*surface:get_height()-2*height_coinbox },
	utils.absolute_path("data/fonts/DroidSans.ttf"))
	text_player:draw_over_surface(surface, "Player")

	local text_computer = sys.new_freetype(coin_color_computer, 22, {x = 0.05 * surface:get_width() , y = 0.5*surface:get_height()+0.1*height_coinbox },
	utils.absolute_path("data/fonts/DroidSans.ttf"))
	text_computer:draw_over_surface(surface, "Computer")

	surface:clear(coin_color_player, {x=0.1*surface:get_width(), y=0.5*surface:get_height()-1.5*height_coinbox, width = width_coinbox, height = height_coinbox})
	surface:clear(coin_color_computer, {x=0.1*surface:get_width(), y=0.5*surface:get_height()+0.5*height_coinbox, width = width_coinbox, height = height_coinbox})

end

return ConnectFourComponent
