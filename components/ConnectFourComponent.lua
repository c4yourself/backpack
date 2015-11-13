local class = require("lib.classy")
local ConnectFour = require("lib.connectfour.ConnectFour")
local event = require("lib.event")
local View = require("lib.view.View")
local utils = require("lib.utils")
local subsurface = require("lib.view.SubSurface")
local area = require("lib.draw.Rectangle")
local font = require("lib.font.Font")
local color = require("lib.draw.Color")

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

	elseif key == "left" then
		if self.current_column == 1 then
			self.current_column = 7
		else
			self.current_column = self.current_column - 1
		end

	elseif key == "ok" then
		self.connectfour:move(self.connectfour:get_player(), self.current_column)
		print(self.connectfour:serialize())

	elseif key == "exit" then
		local exit_popup = subsurface(surface, area(100, 100, 400, 400))
		local color_popup = color(255, 255, 255, 255)
		local font_popup = font("data/fonts/DroidSans.ttf", 16, color_popup)
		exit_popup:clear({r=255, g=255, b=255}, area(100, 100, 400, 400))
		font_popup:draw(exit_popup, area(30,30,400,400), "Spelare X vann!")

	end
	self:dirty(true)
	print(self.current_column)
end

function ConnectFourComponent:top_row(surface, column)
	local posx = 0.35*surface:get_width()
	local current_color = {r = 0, g = 0, b = 0}
	local color = {r = 0, g = 0, b = 0}
	local current_player = self.connectfour:get_player()
	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}
	print(current_player)
	print("test:" .. column)
	for j = 1, 7 do

		if current_player == "X" then
			current_color = coin_color_player
		else
			current_color = coin_color_computer
		end

		if j == column then
			color = current_color
		end
		surface:clear(color, {x=posx, y=posy, width = width_coinbox, height = height_coinbox})
		posx = posx + width_coinbox
		color = {r = 0, g = 0, b = 0}
	end
end

function ConnectFourComponent:render(surface)
	self:dirty(false)


	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}
	local temp_color

	width_coinbox = (1/7)*(0.45)*surface:get_width()
	height_coinbox = (1/7)*(0.8)*surface:get_height()
	--surface:clear({r=255, g=255, b=255}, {x=10, y=10, width = surface:get_width()*0.5, height = surface:get_height()*0.5})
	--surface:clear({r=255, g=255, b=255}, {x=100, y=100, width = width_coinbox, height = height_coinbox})

	local posy = 0.1*surface:get_height()

	self:top_row(surface, self.current_column)

	for i = 1, 6 do
		local posx = 0.35*surface:get_width()
        for j = 1, 7 do
					if self.connectfour:get(i,j) == nil then
						temp_color = {r=255, g=255, b=255}
					elseif self.connectfour:get(i,j) == "X" then
						temp_color = coin_color_player
					elseif self.connectfour:get(i,j) == "O" then
						temp_color = coin_color_computer
					end

          surface:clear(temp_color, {x=posx, y=posy, width = width_coinbox, height = height_coinbox})
					posx = posx + width_coinbox
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

	if self.connectfour:get_player() == "O" then
		local AI_column = self.connectfour:computer_AI()
		self.connectfour:move("O", AI_column)
		self:dirty(true)
	end


	if self.connectfour:get_winner() ~= nil then
		local winner_popup = subsurface(surface, area(100, 100, 400, 400))
		local color_popup = color(243, 137, 15, 255)
		local font_popup = font("data/fonts/DroidSans.ttf", 16, color_popup)
		winner_popup:clear(color_popup
		--, area(100, 100, 400, 400)
		)
		font_popup:draw(winner_popup, area(30,30,400,400), "Spelare X vann!")
	end
	--[[local callback = function()
		if self.connectfour:find_winner
		print("JAG KÖR")
		local winner_popup = subsurface(surface, area(100, 100, 400, 400))
		local color_popup = color(255, 255, 255, 255)
		local font_popup = font("data/fonts/DroidSans.ttf", 16, color_popup)
		winner_popup:clear(coin_color_player)
		font_popup:draw(winner_popup, area(30,30,400,400), "Spelare X vann!")
	end
	self:listen_to(self.connectfour, "Winner_trigger_popup", callback)]]--

--	local popup_text = sys.new_freetype({r = 255, g = 128, b = 0, a = 255}, 22,
--	{x=100,y=100}, utils.absolute_path("data/fonts/DroidSans.ttf")) ""
--	popup_text:draw_over_surface(confirmation_popup, "Vill du verkligen avsluta?")

end




return ConnectFourComponent
