---Connect Four GUI
--@classmod ConnectFourComponent

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local ConnectFour = require("lib.connectfour.ConnectFour")
local draw = require("lib.draw")
local event = require("lib.event")
local ExpCalc = require("lib.scores.experiencecalculation")
local Font = require("lib.draw.Font")
local PopUpView = require("views.PopUpView")
local Rectangle = require("lib.draw.Rectangle")
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local View = require("lib.view.View")

local ConnectFourComponent = class("ConnectFourComponent", View)

--- Constructor for ConnectFour component
-- @param remote_control
function ConnectFourComponent:__init(remote_control, subsurface, profile)
	View.__init(self)

	self.profile = profile
	self.connectfour = ConnectFour()
	self.current_column = 4
	self:focus()

	self.images = {
		background = gfx.loadpng("data/images/connect_four/connect4-background.png"),
		board = gfx.loadpng("data/images/connect_four/connect4board1.png"),
		player_coin_cover_red = gfx.loadpng("data/images/connect_four/player_coin_cover_red.png"),
		player_coin_cover_yellow = gfx.loadpng("data/images/connect_four/player_coin_cover_yellow.png"),
		top_row_cover = gfx.loadpng("data/images/connect4toprow.png"),
	}

	self.button_font = Font(
		"data/fonts/DroidSans.ttf", 21, Color(255, 255, 255, 255))
	self.player_font = Font(
		"data/fonts/DroidSans.ttf", 22, Color(255, 255, 51, 255))
	self.computer_font = Font(
		"data/fonts/DroidSans.ttf", 22, Color(255, 0, 0, 255))
end

function ConnectFourComponent:destroy()
	View.destroy(self)

	for _, image in pairs(self.images) do
		image:destroy()
	end
end

--- Responds differently depending on which key pressed on the remote control
-- @param key, the key pressed on the remote control
function ConnectFourComponent:press(key)
	if key == "right" then
		repeat
			if self.current_column == 7 then
				self.current_column = 1
			else
				self.current_column = self.current_column + 1
			end
		until self.connectfour:get_current_row(self.current_column) ~= 0
		self:dirty()
	elseif key == "left" then
		repeat
			if self.current_column == 1 then
				self.current_column = 7
			else
				self.current_column = self.current_column - 1
			end
		until self.connectfour:get_current_row(self.current_column) ~= 0
		self:dirty()
	elseif key == "ok" then
		self.connectfour:move(self.connectfour:get_player(), self.current_column)
		self:blur()
		self:dirty()

		if self.connectfour:get_winner() == nil then
			utils.delay(1000, function()
				self:delay()
				self:focus()
			end)
		end
	elseif key == "red" then
		local type = "confirmation"
		local message =  {"Are you sure you want to exit?"}
		self:_back_to_city(type, message)
		self:dirty(false)
		self:dirty(true)
	end
end

---Prints out the top row
-- @param surface
-- @param column, the column that the coin will be placed into
-- @param width_coinbox, width of a single coinbox
-- @param height_coinbox, height of a single coinbox
function ConnectFourComponent:top_row(surface, column, width_coinbox, height_coinbox)
	local posx = 0.41*surface:get_width()
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

--- Prints the surface connected with ConnectFour
-- @param surface
function ConnectFourComponent:render(surface)
	surface:fill({r = 0, g = 0, b = 0, a = 255})

	local coin_color_player = {r=255, g=255, b=51}
	local coin_color_computer = {r=255, g=0, b=0}
	local temp_color
	local width_coinbox = math.floor((1/7)*(0.45)*surface:get_width())
	local height_coinbox = math.floor((1/7)*(0.8)*surface:get_height())
	local posy = 0.1*surface:get_height()+ 0.5*height_coinbox
	local posy_constant = 0.1*surface:get_height()+ 0.5*height_coinbox
	local posx_constant = 0.41*surface:get_width()
	self:top_row(surface, self.current_column, width_coinbox, height_coinbox)

	surface:copyfrom(self.images.background,nil,{x=posx_constant, y=posy_constant-4, width = 7*width_coinbox+4, height = 6*height_coinbox+4}, true)


	--prints the board
	for i = 1, 6 do
		local posx = 0.41*surface:get_width()
		for j = 1, 7 do
			if self.connectfour:get(i,j) == nil then
				temp_color = {r=255, g=255, b=255}
			elseif self.connectfour:get(i,j) == "X" then
				temp_color = coin_color_player
				surface:clear(temp_color, {x=posx, y=posy, width = width_coinbox, height = height_coinbox})

			elseif self.connectfour:get(i,j) == "O" then
				temp_color = coin_color_computer
				surface:clear(temp_color, {x=posx, y=posy, width = width_coinbox, height = height_coinbox})

			end

			posx = posx + width_coinbox
		end

		posy = posy + height_coinbox
	end

	local left_board = SubSurface(surface,{width = 300, height = surface:get_height()-150, x = 75, y = 75})

	left_board:clear(Color(250, 105, 0, 255):to_table())
	left_board:fill({r = 65, g = 70, b = 72, a = 255},
		{x = 5, y = 5, width = 290, height = surface:get_height()-160})

	left_board:fill(Color(250, 105, 0, 255):to_table(),
		{x = 5, y = 75, width = 290, height = 5})
	local text_color = Color(255,255,255,255)
	local text = Font("data/fonts/DroidSans.ttf", 30, text_color)
		text:draw(left_board, {x = 65, y = 20}, "ConnectFour")

	--Back to city button
	local target1 = Rectangle(
		80,
		445,
		290,
		78)
	surface:clear(Color(250, 105, 0, 255):to_table(), target1:to_table())
	self.button_font:draw(surface, target1:to_table(), "Press Back to go back to City", "center", "middle")


	--text player + yellow circle
	local target3 = Rectangle(
		0.09 * surface:get_width(),
		0.62 * surface:get_height() - 3 * height_coinbox,
		200,
		60)
	self.player_font:draw(surface, target3:to_table(), "Player")
	surface:copyfrom(self.images.player_coin_cover_yellow,nil,{x=0.09*surface:get_width(), y=0.62*surface:get_height()-2.5*height_coinbox, width = width_coinbox, height = height_coinbox}, true)

	--text computer + red circle
	local target4 = Rectangle(
		0.09 * surface:get_width(),
		0.58 * surface:get_height() - 0.9 * height_coinbox,
		200,
		60)
	self.computer_font:draw(surface, target4:to_table(), "Computer")
	surface:copyfrom(self.images.player_coin_cover_red,nil,{x=0.09*surface:get_width(), y=0.58*surface:get_height()-0.5*height_coinbox+8, width = width_coinbox, height = height_coinbox}, true)

	--insert picture over board
	surface:copyfrom(self.images.board,nil,{x=posx_constant, y=posy_constant, width = 7*width_coinbox, height = 6*height_coinbox}, true)
	surface:copyfrom(self.images.top_row_cover,nil,{x=posx_constant, y=0.1*surface:get_height() - 0.5*height_coinbox-4, width = 7*width_coinbox, height = height_coinbox}, true)

	if self.connectfour:_is_full_board() then
		utils.delay(2500, function()
			local message = {"The board is full, no one won."}
			self:delay2("message", message)
		end)
	end

	if self.connectfour:get_winner() ~= nil then
		utils.delay(2500, function()
			local winner = self.connectfour:get_winner()
			if winner == "X" then
				local count_x = self.connectfour:get_number_of_coins()
				local experience = ExpCalc.Calculation(count_x, "Connectfour")
				local last_level = (self.profile.experience-(self.profile.experience%100))/100+1
				self.profile:modify_balance(experience)
				self.profile:modify_experience(experience)
				local city = self.profile:get_city()
				local new_level = (self.profile.experience-(self.profile.experience%100))/100+1
				if last_level == new_level then
					winner_message = {"Congratulations, you won!", "You received " .. experience .. " experience and "
				 								.. city.country:format_balance(experience) .. "."}
				else
					winner_message = {"Congratulations, you won!", "You received " .. experience .. " experience and "
				 								.. city.country:format_balance(experience) .. "." ,
														"You have now reached level " .. new_level .. "!"}
				end
			elseif winner == "O" then
				winner_message = {"Sorry, you lost!"}
			end

			self:delay2("message", winner_message)
		end)
	end

	if self.sub_view ~= nil then
		local subsurface = SubSurface(screen,{width=screen:get_width()*0.5, height=(screen:get_height()-50)*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25+50})
		self.sub_view:render(subsurface)
	end

	self:dirty(false)
end

--- Puts a delay on computers move to slow down the process
function ConnectFourComponent:delay()
	local AI_column = self.connectfour:computer_AI(self.current_column)

	self.connectfour:move("O", AI_column)

	repeat
		if self.connectfour:get_player() == nil then
			break

		end
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

---Delays the winner pop-up after the game have finished
-- @param surface
function ConnectFourComponent:delay2(type, message)
	self:_back_to_city(type,message)
	self:dirty(false)
	self:dirty(true)
end

function ConnectFourComponent:_back_to_city(type, message)
	local subsurface = SubSurface(screen,{width=screen:get_width()*0.5, height=(screen:get_height()-50)*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25+50})
	local popup_view = PopUpView(remote_control,subsurface, type, message)
	self.sub_view = popup_view
	self:add_view(popup_view, true)

	self:blur()

	local button_click_func = function(button)
		if button == "ok" then
			self:destroy()
			self:trigger("exit_view")
		else
			self.sub_view = nil
			popup_view:destroy()
			self:focus()
			self:dirty(true)
		end
	end

	self:listen_to_once(popup_view, "button_click", button_click_func)
	--popup_view:render(subsurface)
end

function ConnectFourComponent:focus()
	self:listen_to(
	event.remote_control,
	"button_press",
	utils.partial(self.press, self)
	)
end

function ConnectFourComponent:blur()
	self:stop_listening(event.remote_control)
end

return ConnectFourComponent
