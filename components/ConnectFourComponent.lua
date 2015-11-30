---Connect Four GUI
--@classmod ConnectFourComponent


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
local PopUpView = require("views.PopUpView")
local SubSurface = require("lib.view.SubSurface")
local ExpCalc = require("lib.scores.experiencecalculation")


local ConnectFourComponent = class("ConnectFourComponent", View)

--- Constructor for ConnectFour component
-- @param remote_control
function ConnectFourComponent:__init(remote_control)
	View.__init(self)

	self.connectfour = ConnectFour()
	self.current_column = 4
	self:focus()

	-- self:listen_to(
	-- event.remote_control,
	-- "button_press",
	-- utils.partial(self.press, self)
	-- )
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
		--self:stop_listening(event.remote_control)
		self:dirty()
	print(self.connectfour:get_winner())
		if self.connectfour:get_winner() == nil then

		self.computer_delay = sys.new_timer(1000, function()
			self:delay()
			self.computer_delay:stop()
		end)


		self.computer_delay:start()
		end
	elseif key == "exit" then
		--TODO pop-up
	--	local exit_popup = subsurface(surface, area(100, 100, 400, 400))
	--	local color_popup = color(255, 255, 255, 255)
	--	local font_popup = font("data/fonts/DroidSans.ttf", 16, color_popup)
	--	exit_popup:clear({r=255, g=255, b=255}, area(100, 100, 400, 400))
	--	font_popup:draw(exit_popup, area(30,30,400,400), "Spelare X vann!")
		--self:trigger("exit_view")
		local type = "confirmation"
    --local message = {"Hej hopp"}
    local message =  {"Are you sure you want to exit?"}
		self:_back_to_city(type, message)

	end

end

---Prints out the top row
-- @param surface
-- @param column, the column that the coin will be placed into
-- @param width_coinbox, width of a single coinbox
-- @param height_coinbox, height of a single coinbox
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

--- Prints the surface connected with ConnectFour
-- @param surface
function ConnectFourComponent:render(surface)
	surface:fill({r = 0, g = 0, b = 0, a = 255})


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
	local target1 = area(0.05*surface:get_width(),0.9*surface:get_height()-1.5*height_coinbox, 300, 60)
	surface:clear(color(255, 255, 255, 255):to_table(), target1:to_table())
	f:draw(surface, target1:to_table(), "Back to City View, press Return", "center", "middle")

	--heading
	local heading = font("data/fonts/DroidSans.ttf", 32, color(255, 128, 0, 255))
	local target2 = area(0.05*surface:get_width(),0.1*surface:get_height(), 200, 60)
	heading:draw(surface, target2:to_table(), "Connect Four")

	--text player + yellow box
	local text_player = font("data/fonts/DroidSans.ttf", 22, color(255, 255, 51, 255))
	local target3 = area(0.05*surface:get_width(),0.5*surface:get_height()-2*height_coinbox, 200, 60)
	text_player:draw(surface, target3:to_table(), "Player")
		surface:clear(coin_color_player, {x=0.055*surface:get_width(), y=0.5*surface:get_height()-1.5*height_coinbox, width = width_coinbox, height = height_coinbox})

	--text compunter + red box
	local text_computer = font("data/fonts/DroidSans.ttf", 22, color(255, 0, 0, 255))
	local target4 = area(0.05*surface:get_width(),0.5*surface:get_height()+0.1*height_coinbox, 200, 60)
	text_computer:draw(surface, target4:to_table(), "Computer")
	surface:clear(coin_color_computer, {x=0.055*surface:get_width(), y=0.5*surface:get_height()+0.5*height_coinbox+8, width = width_coinbox, height = height_coinbox})

	--insert picture over board
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/connect4board.png")),nil,{x=posx_constant, y=posy_constant, width = 7*width_coinbox, height = 6*height_coinbox})
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/connect4toprow.png")),nil,{x=posx_constant, y=0.1*surface:get_height() - 0.5*height_coinbox, width = 7*width_coinbox, height = height_coinbox})


	if self.connectfour:get_player() == nil then
		print("brädet är fullt")
		self.no_winner_delay = sys.new_timer(2500, function()
			local message = {"The board is full, no one won. Return to city view"}
			self:delay2("message", message)
			self.no_winner_delay:stop()
		end)
		self.no_winner_delay:start()


	end

	if self.connectfour:get_winner() ~= nil then
		print("någon har vunnit")
		self.winner_delay = sys.new_timer(2500, function()
			local winner = self.connectfour:get_winner()
			if winner == "X" then
				winner_message = {"Congratulations, you won!"}
				local count_x = self.connectfour:get_number_of_coins()
				ExpCalc.Calculation(count_x, "Connectfour")

			elseif winner == "O" then
				winner_message = {"Sorry, you lost!"}
			end

			self:delay2("message", winner_message)
			self.winner_delay:stop()
		end)
		self.winner_delay:start()
	end



	self:dirty(false)
	gfx.update()
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

	self:focus()

	-- self:listen_to(
	-- event.remote_control,
	-- "button_press",
	-- utils.partial(self.press, self)
	-- )

		self:dirty(true)
end

---Delays the winner pop-up after the game have finished
-- @param surface
function ConnectFourComponent:delay2(type, message)
	--self.stop_timer:stop()
	self:_back_to_city(type,message)
--	self:trigger("exit_view")
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

function ConnectFourComponent:_back_to_city(type, message)
    --self:destroy()
    -- TODO Implement/connect pop-up for quit game
    -- Appendix 2 in UX design document
    -- Trigger exit event
    --local type = "confirmation"
    --local message = {"Hej hopp"}
    --local message =  {"Are you sure you want to exit?"}

    local subsurface = SubSurface(screen,{width=screen:get_width()*0.5, height=(screen:get_height()-50)*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25+50})
    --local pop_instance = self.button_grid:display_next_view(self.button_1.transfer_path)
    local popup_view = PopUpView(remote_control,subsurface, type, message)
    self:add_view(popup_view)
    --local popup_view = PopUpView(remote_control,subsurface,type,message)


  --  local popup_view = SubSurface(screen,{width=screen:get_width()*0.5, height=screen:get_height()*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25})
    --local pop = PopUpView(remote_control, popup_view, type, message)
    	self:blur()
    --self.views.button_grid:stop_listening(self.views.button_grid.event_listener,
                        --      "button_press",
                          --    callback)
    -- local exit_view_func = function()
    --   --Exit View
    --   self:trigger("exit_view")
    -- end
		--
    -- local destroy_pop = function()
    --   popup_view:destroy()
		-- 	self:focus()
    --   self:dirty(true)
    --   gfx.update()
    -- end

		local button_click_func = function(button)
			if button == "ok" then
			self:trigger("exit_view")
			else
			popup_view:destroy()
			self:focus()
			self:dirty(true)
			gfx.update()
		end
		end

		self:listen_to_once(popup_view, "button_click", button_click_func)
--    self:listen_to_once(popup_view,"exit_view",exit_view_func)
--    self:listen_to_once(popup_view, "destroy", destroy_pop)
    popup_view:render(subsurface)
    gfx.update()
  --  self:trigger("exit_view")
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
