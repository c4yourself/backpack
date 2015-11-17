local class = require("lib.classy")
local ConnectFour = require("lib.connectfour.ConnectFour")
local event = require("lib.event")
local View = require("lib.view.View")
local utils = require("lib.utils")
local subsurface = require("lib.view.SubSurface")
local area = require("lib.draw.Rectangle")
local font = require("lib.draw.Font")
local color = require("lib.draw.Color")
local button = require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")

local ConnectFourComponent = class("ConnectFourComponent", View)

function ConnectFourComponent:__init(remote_control)
	View.__init(self)

	self.connectfour = ConnectFour()
	self.current_column = 4

	self:listen_to(
	event.remote_control,
	"button_release",
	utils.partial(self.press, self)
	)
end

function ConnectFourComponent:press(key)
	if key == "right" then
		repeat
			if self.current_column == 7 then
				self.current_column = 1
			else
				self.current_column = self.current_column + 1
			end
		until self.connectfour:get_current_row(self.current_column) ~= 0

	elseif key == "left" then
		repeat
			if self.current_column == 1 then
				self.current_column = 7
			else
				self.current_column = self.current_column - 1
			end
		until self.connectfour:get_current_row(self.current_column) ~= 0

	elseif key == "ok" then
		self.connectfour:move(self.connectfour:get_player(), self.current_column)

	elseif key == "exit" then
		local exit_popup = subsurface(surface, area(100, 100, 400, 400))
		local color_popup = color(255, 255, 255, 255)
		local font_popup = font("data/fonts/DroidSans.ttf", 16, color_popup)
	--	exit_popup:clear({r=255, g=255, b=255}, area(100, 100, 400, 400))
	--	font_popup:draw(exit_popup, area(30,30,400,400), "Spelare X vann!")
		self.trigger("exit_view")
	end

	self:dirty(false)
	self:dirty(true)
end

--prints out the top row
function ConnectFourComponent:top_row(surface, column, width_coinbox, height_coinbox)
	local posx = 0.35*surface:get_width()
	local posy = 0.1*surface:get_height() - 0.5*height_coinbox
	local current_color = {r = 0, g = 0, b = 0}
	local color = {r = 0, g = 0, b = 0}
	local current_player = self.connectfour:get_player()
	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}

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
	--btn
--[[	local button_color = color(0, 128, 225, 255)
	local text_color = color(55, 55, 55, 255)
	local button_1 = button(button_color, color_selected, color_disabled,true,true)
	local position_1={x=100,y=50}
	local button_size_1 = {width=500,height=100}
	self.buttonGrid = button_grid()
	self.buttonGrid:add_button(position_1,button_size_1,button_1, true, true )
	button_1:set_textdata("Numerical quiz",text_color,{x=100,y=50},30,utils.absolute_path("data/fonts/DroidSans.ttf"))
	self.buttonGrid:render(surface) --]]

	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}
	local temp_color
	local	width_coinbox = math.floor((1/7)*(0.45)*surface:get_width())
	local height_coinbox = math.floor((1/7)*(0.8)*surface:get_height())
	local posy = 0.1*surface:get_height()+ 0.5*height_coinbox
	local posy_constant = 0.1*surface:get_height()+ 0.5*height_coinbox
	local posx_constant = 0.35*surface:get_width()

	self:top_row(surface, self.current_column, width_coinbox, height_coinbox)

	--print the board
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

	--Back to city button
	local f = font("data/fonts/DroidSans.ttf", 16, color(255, 128, 0, 255))
	local target1 = area(0.05*surface:get_width(),0.9*surface:get_height()-1.5*height_coinbox, 200, 60)
	surface:clear(color(255, 255, 255, 255), target1:to_table())
	f:draw(surface, target1:to_table(), "Back to the city", "center", "middle")

	--heading
	local heading = font("data/fonts/DroidSans.ttf", 32, color(255, 128, 0, 255))
	local target2 = area(0.05*surface:get_width(),0.1*surface:get_height(), 200, 60)
	heading:draw(surface, target2:to_table(), "Connect Four")

	--text player + yellow box
	local text_player = font("data/fonts/DroidSans.ttf", 22, color(255, 255, 51, 255))
	local target3 = area(0.05*surface:get_width(),0.5*surface:get_height()-2*height_coinbox, 200, 60)
	text_player:draw(surface, target3:to_table(), "Player")
		surface:clear(coin_color_player, {x=0.1*surface:get_width(), y=0.5*surface:get_height()-1.5*height_coinbox, width = width_coinbox, height = height_coinbox})

	--text compunter + red box
	local text_computer = font("data/fonts/DroidSans.ttf", 22, color(255, 0, 0, 255))
	local target4 = area(0.05*surface:get_width(),0.5*surface:get_height()+0.1*height_coinbox, 200, 60)
	text_computer:draw(surface, target4:to_table(), "Computer")
	surface:clear(coin_color_computer, {x=0.1*surface:get_width(), y=0.5*surface:get_height()+0.5*height_coinbox, width = width_coinbox, height = height_coinbox})

	--insert picture over board
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/connect4board.png")),nil,{x=posx_constant, y=posy_constant})
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/connect4toprow.png")),nil,{x=posx_constant, y=0.1*surface:get_height() - 0.5*height_coinbox})

	--delays if it's the computers turn
	if self.connectfour:get_player() == "O" then
		local callback = utils.partial(self.delay, self, surface)
		self.stop_timer = sys.new_timer(500, callback)
	end

	if self.connectfour:get_winner() ~= nil then
		local winner_popup = subsurface(surface, area(100, 100, 400, 400))
		local color_popup = color(243, 137, 15, 255)
		local font_popup = font("data/fonts/DroidSans.ttf", 16, color(0,0,0,255))
		local winner = self.connectfour:get_winner()
		winner_popup:clear(color_popup)
		if winner == "X" then
			winner_message = "Congratulations, you won!"
		elseif winner == "O" then
			winner_message = "Sorry, you lost!"
		end

		font_popup:draw(winner_popup, area(30,30,400,400), winner_message)

		local callback = utils.partial(self.delay2, self, surface)
		self.stop_timer = sys.new_timer(5000, callback)
	end
end



function ConnectFourComponent:delay(surface)

	self.stop_timer:stop()

	local AI_column = self.connectfour:computer_AI(self.current_column)
	self.connectfour:move("O", AI_column)

	repeat
		if self.connectfour:get_current_row(self.current_column) == 0 then
			if self.current_column == 7 then
				self.current_column = 1
			else
				self.current_column = self.current_column + 1
			end
		end
	until self.connectfour:get_current_row(self.current_column) ~= 0

		self:dirty(true)
end


	function ConnectFourComponent:delay2(surface)
		self.stop_timer:stop()
		self.trigger("exit_view")
	end




--[[	repeat
		if self.connectfour:get_current_row(self.current_column) == 0 then

			if self.current_column == 7 then
				self.current_column = 1
			else
				self.current_column = self.current_column + 1
			end
		end
	until self.connectfour:get_current_row(self.current_column) ~= 0
end ]]--



return ConnectFourComponent
