local class = require("lib.classy")
local ConnectFour = require("lib.connectfour.ConnectFour")
local event = require("lib.event")
local View = require("lib.view.View")
local utils = require("lib.utils")

local ConnectFourComponent = class("ConnectFourComponent", View)

function ConnectFourComponent:__init(remote_control)
	View.__init(self)

	self.connectfour = ConnectFour()
	self.current_column = 3

	self:listen_to(
	event.remote_control,
	"button_release",
	utils.partial(self.press, self)
	)
end

function ConnectFourComponent:press(key)
	if key == "right" then
		if self.current_column == 7 then
			self.current_column = 1
		else
			self.current_column = self.current_column + 1
		end
		self:dirty(true)
		print(self.current_column)
		--self:dirty(false)

	elseif key == "left" then
		if self.current_column == 1 then
			self.current_column = 7
		else
			self.current_column = self.current_column - 1
		end
		--self:dirty(false)
		self:dirty(true)
		print(self.current_column)



	end
end

function ConnectFourComponent:top_row(surface, column)
	local posx = 0.35*surface:get_width()
	local color = {r = 0, g = 0, b = 0}

	print("test:" .. column)
	for j = 1, 7 do
		if j == column then
			color = {r=255, g=255, b=51}
		end
		surface:clear(color, {x=posx, y=posy, width = width_coinbox, height = height_coinbox})
		posx = posx + width_coinbox
		color = {r = 0, g = 0, b = 0}
	end
end

function ConnectFourComponent:render(surface)
print("crender")
	self:dirty(false)
	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}

	width_coinbox = (1/7)*(0.45)*surface:get_width()
	height_coinbox = (1/7)*(0.8)*surface:get_height()
	--surface:clear({r=255, g=255, b=255}, {x=10, y=10, width = surface:get_width()*0.5, height = surface:get_height()*0.5})
	surface:clear({r=255, g=255, b=255}, {x=10, y=surface:get_height()-height_coinbox, width = width_coinbox, height = height_coinbox})
	--surface:clear({r=255, g=255, b=255}, {x=100, y=100, width = width_coinbox, height = height_coinbox})

	local posy = 0.1*surface:get_height()
	local tempcolor = 255

	self:top_row(surface, self.current_column)

	for i = 1, 6 do
		local posx = 0.35*surface:get_width()
        for j = 1, 7 do
          surface:clear({r=tempcolor, g=tempcolor, b=tempcolor}, {x=posx, y=posy, width = width_coinbox, height = height_coinbox})
					posx = posx + width_coinbox
					tempcolor = tempcolor - 5
        end

				posy = posy + height_coinbox
  end



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
