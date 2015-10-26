--- Event class.
-- @classmod Event

local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")

--local Event = class("Event")
local ConnectFour = class("ConnectFour")

--Constructor for ConnectFour
function ConnectFour:__init()
 --table som innehåller spelplan
  self.board={{},{},{},{},{},{}}
  self.player="X"
  --self.board[1][1]="X"
  --[[self.board[1][2]="X"
  self.board[1][3]="X"
  self.board[1][4]="X"
  self.board[1][5]="X"
  self.board[1][6]="X"
  self.board[1][7]="X"
  self.board[2][1]="O"
  self.board[2][2]="O"
  self.board[2][3]="O"
  self.board[2][4]="O"
  self.board[2][5]="O"
  self.board[2][6]="O"
  self.board[2][7]="O"
  self.board[3][1]="O"
  self.board[3][2]="O"
  self.board[3][3]="O"
  self.board[3][4]="O"
  self.board[3][5]="O"
  self.board[3][6]="O"
  self.board[3][7]="O"
  self.board[4][1] = "X"
  self.board[4][2] = "X"
  self.board[4][3] = "X"
  self.board[4][4] = "X"
  self.board[4][5] = "X"
  self.board[4][6] = "X"
  self.board[4][7] = "X"
  self.board[5][1]="O"
  self.board[5][2]="O"
  self.board[5][3]="O"
  self.board[5][4]="O"
  self.board[5][5]="O"
  self.board[5][6]="O"
  self.board[5][7]="O"
  self.board[6][1] = "X"
  self.board[6][2] = "X"
  self.board[6][3] = "X"
  self.board[6][4] = "X"
  self.board[6][5] = "X"
  self.board[6][6] = "X"
  self.board[6][7] = "X" --]]
  self.board[6][1] = "X"
  self.board[5][1]="O"
  self.board[4][1] = "X"
  self.board[3][1] = "O"
  self.board[2][1] = "X"
  --self.board[1][1] = "X"
end

--Converts the board to a string
function ConnectFour:serialize()
  local output=""
  for row = 1, 6 do
        for column=1,7 do
          if self.board[row][column]==nil then
            output=output.."~"
          else
            output=output..self.board[row][column]
          end
        end
        output=output.."\n"
    end
  return output
end

--Returns the color of the disc at the given position. If there is no disc in the given column nil is returned
function ConnectFour:get(row, column)
  local output=self.board[row][column]
  return output
end

--Returns the current player’s color. If the game is over or there are no free tiles nil is returned
function ConnectFour:get_player()
  local countX=0
  local countO=0

  for row = 1, 6 do
    for column=1,7 do
      if self.board[row][column]=="X" then
        countX=countX+1
      elseif self.board[row][column]=="O" then
        countO=countO+1
      end
    end
  end

  --the board is full
  if countX+countO>=42 then
    return nil
  elseif countX>countO then
    return "O"
  elseif countX<=countO then
    return "X"
  end

end

function ConnectFour:get_current_row(column)
  local row=6
  repeat
    row=row-1
    if row<1 then
      break
    end
    local position=self.board[row][column]
  until position==nil

  return row
end

--Returns true if the given player can add a disc to the given column
function ConnectFour:is_valid_move(player, column)

  row=self:get_current_row(column)

  --print(row)
  --print(self:get_player())

  if row>0 and self:get_player()==player then
    return true
  else
    return false
  end

end

--Drops a disc of the given player into the given column. If the move is invalid an error is raised. If it is not the given player’s turn an error is raised
--[[function ConnectFour:move(player, column)
  if self:is_valid_move(player, column) then
    self.board[]
  end

end--]]

--[[- Internal function for binding callbacks.
-- @param event_type Event type to trigger on
-- @param callback Callback function to run on trigger
-- @param callback_type 0 if callback is permanent, 1 for once only
-- @local
function Event:_on(event_type, callback, callback_type)
	if self.event_callbacks[event_type] == nil then
		self.event_callbacks[event_type] = {}
	end

	self.event_callbacks[event_type][callback] = callback_type
end
--]]



return ConnectFour
