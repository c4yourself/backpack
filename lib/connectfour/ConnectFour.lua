--- Connect four logics
-- @classmod ConnectFour
local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")

local ConnectFour = class("ConnectFour")

--- Constructor for ConnectFour
function ConnectFour:__init()

	self.board = {{},{},{},{},{},{}}
	--{{},{"X", "O", "X", "O", "X", "O"}, {"O", "X", "O","X", "O", "X", "O"},{"O", "X", "O", "X", "O", "X", "O"},{"X", "O", "X", "O", "X", "O", "X"},{"X", "O", "X", "O", "X", "O", "X"}}
	self.player = "X"
end

--- Converts the board to a string
-- @return output a string containing the board

function ConnectFour:serialize()

	local output = ""

	for row = 1, 6 do
		for column = 1, 7 do
			if self.board[row][column] == nil then
				output = output.."~"
			else
				output = output..self.board[row][column]
			end
		end
		output = output.."\n"
	end

	return output
end

--- Create a new ConnectFour's instance with the given state
-- @param state a string containing the current state
-- @return connect_four a ConnectFour's instance
function ConnectFour.unserialize(state)

	local connect_four = ConnectFour()
	local position	= 1

	for row = 1, 6 do
		for column = 1, 7 do
			if string.sub(state, position, position) == "~" then
				connect_four.board[row][column] = nil
			else
			connect_four.board[row][column] = string.sub(state, position, position)
			end
			position = position + 1
		end
		position = position + 1
	end

return connect_four
end


--- Returns the color of the coin at the given position. If there is no coin in the given column nil is returned
-- @param row
-- @param column
-- @return output the value at the given position
function ConnectFour:get(row, column)

	local output = self.board[row][column]
	return output
end

--- Returns the current player’s color. If the game is over or there are no free tiles nil is returned
-- @return a string containting the player
function ConnectFour:get_player()
	local count_X = 0
	local count_O = 0

	for row = 1, 6 do
		for column = 1, 7 do
			if self.board[row][column] == "X" then
				count_X = count_X + 1
			elseif self.board[row][column] == "O" then
				count_O = count_O + 1
			end
		end
	end

	--the board is full
	if count_X + count_O >= 42 then
		return nil
	elseif self:get_winner() ~= nil then
		return nil
	elseif count_X > count_O then
		return "O"
	elseif count_X <= count_O then
		return "X"
	end
end

--- Checks if the board is full
-- @return boolean, true if the board is full
-- @local
function ConnectFour:_is_full_board()
	local count_X = 0
	local count_O = 0

	for row = 1, 6 do
		for column = 1, 7 do
			if self.board[row][column] == "X" then
				count_X = count_X + 1
			elseif self.board[row][column] == "O" then
				count_O = count_O + 1
			end
		end
	end

	--the board is full
	if count_X + count_O >= 42 then
		return true
	else
		return false
	end
end

--- Calculates the number of coins that player has put
-- @param number of coins
function ConnectFour:get_number_of_coins()
	local count_X = 0

	for row = 1, 6 do
		for column = 1, 7 do
			if self.board[row][column] == "X" then
				count_X = count_X + 1
			end
		end
	end

	return count_X
end



--- Calculates which row the coin will stop at given a columnn
-- @param column
-- @return row
function ConnectFour:get_current_row(column)

	local row = 7
	repeat
		row = row - 1
		if row < 1 then
			break
		end
		local position = self.board[row][column]
	until position == nil

	return row
end

--- Resets the game-board to nil, clear the board
function ConnectFour:reset_board()
	for row = 1,6 do
		for column = 1, 7 do
			self.board[row][column] = nil
		end
	end
end

--- Returns true if the given player can add a coin to the given column
-- @param player the player who tries to make a move
-- @param column the column where the player wants to drop the coin
-- @return boolean
function ConnectFour:is_valid_move(player, column)
		local row = self:get_current_row(column)

	if row > 0 and column >= 1 and column <= 7 and self:get_player() == player then
		return true
	else
		return false
	end
end

--- Drops a coin of the given player into the given column. If the move is invalid an error is raised. If it is not the given player’s turn an error is raised
-- @param player the player who makes the move
-- @param column the column where the player puts the coin
function ConnectFour:move(player, column)

	--guard condition
	if not self:is_valid_move(player, column) then
		error("invalid move")
	end

	local row_1 = self:get_current_row(column)
	self.board[row_1][column] = player
end

---Checks if there is a winner
-- @param player the player who made the last move
-- @param row the row where the last move was made
-- @param column the column where the last move was made
-- @return player string containing the player if there is a winner else nil
--@local
function ConnectFour:_find_winner(player, row, column)

	local count = 0
	local current_row = row
	local current_column = column

	-- check row
	current_column = 1

	repeat
		if self:get(row, current_column) == player then
			count = count + 1
		else
			count = 0
		end

		if count == 4 then
			return player
		end

		current_column = current_column + 1

	until current_column > 7

	-- check column
	count = 0
	current_row = 1

	repeat
		if self:get(current_row, column) == player then
			count = count + 1
		else
			count = 0
		end

		if count == 4 then
			return player
		end

		current_row = current_row + 1

	until current_row > 6

	-- check diagonal 1
	current_row = row
	current_column = column
	count = 0

	if current_row ~= 6 and current_column ~= 1 then
	repeat
		current_row = current_row + 1
		current_column = current_column -1
	until current_row == 6 or current_column == 1
	end

	repeat
		if self:get(current_row, current_column) == player then
			count = count + 1
		else
			count = 0
		end

		if count == 4 then
			return player
		end

		current_row = current_row - 1
		current_column = current_column + 1

	until current_row < 1 or current_column > 7

	-- check diagonal 2
	current_row = row
	current_column = column
	count = 0

	if current_row ~= 1 and current_column ~= 1 then
	repeat
		current_row = current_row - 1
		current_column = current_column - 1
	until current_row==1 or current_column == 1
	end

	repeat
		if self:get(current_row, current_column) == player then
			count = count + 1
		else
			count = 0
		end

		if count == 4 then
			return player
		end

		current_row = current_row + 1
		current_column = current_column + 1

	until current_row > 6 or current_column > 7

	return nil
end

---Checks if there is a winner by calling _find_winner() with the top-coin in each column as a parameter
-- @return player string containing the player if there is a winner else nil
function ConnectFour:get_winner()
	for i = 1, 7 do
		local row = self:get_current_row(i)
		if row ~= 6 then
			local player = self:get(row+1, i)
			if player ~= nil then
				local winner = self:_find_winner(player, row+1, i)
				if winner ~= nil then
					return winner
				end
			end
		end

	end
return nil
end

function ConnectFour:_check_three_in_a_column(row, column)
	--column
	if row<4 then
		if self:get(row+2, column) == self:get(row+1, column) then
			if self:get(row+1, column)== self:get(row+3, column) then
			return true
			end
		end
	end
	return false
end


--- Decides which column the computer should choose during next move
-- @param x_column , column for the last put coin by the player
-- @return random_column, number choosen column
function ConnectFour:computer_AI(x_column)

	local random_column -- = math.random(1,7)
	local random_probability = math.random(1,10) --probability

	--check if there's three in a row
	for i = 1, 7 do
		local row = self:get_current_row(i)

		if row > 0 then
		local make_move = self:_check_three_in_a_column(row, i)
			if make_move == true then
				return i
			end
		end
	end


	if self:get_player() ~= "O" then
		error("Computer AI called when player turn")
	end

	local counter = 0
repeat
	if random_probability < 8 then
		counter = counter + 1
			local random_close = math.random(-1, 1)
			random_column = x_column + random_close


			if counter == 5 then
				random_probability = 8
			end

	elseif random_probability >= 8 then
		random_column = math.random(1,7)

	end
	until self:is_valid_move("O", random_column)

	return random_column

end

return ConnectFour
