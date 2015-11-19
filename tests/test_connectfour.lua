local luaunit = require("luaunit")
local ConnectFour = require("lib.connectfour.ConnectFour")

local TestConnectFour = {}

local boards = {
	-- Full table
	"XOXOXOO\n" ..
	"XOXOXOX\n" ..
	"OXOXOXO\n" ..
	"OXOXOXO\n" ..
	"XOXOXOX\n" ..
	"XOXOXOX\n",

	-- X winner vertical
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"X~~~~~~\n" ..
	"XO~~~~~\n" ..
	"XO~~~~~\n" ..
	"XO~~~~~\n",

	-- X winner horizontal
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~OOO\n" ..
	"~~~XXXX\n",

	-- X winner diagonal
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~X~~~\n" ..
	"~~XX~~~\n" ..
	"~XOO~~~\n" ..
	"XOOXO~~\n",

	-- O winner diagonal
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~O~~~\n" ..
	"~~~XO~~\n" ..
	"~~~OXO~\n" ..
	"~~~XXXO\n",

	-- Full column no winner
	"O~~~~~~\n" ..
	"X~~~~~~\n" ..
	"O~~~~~~\n" ..
	"X~~~~~~\n" ..
	"O~~~~~~\n" ..
	"X~~~~~~\n",

	-- Row no winner
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~X~~~~~\n" ..
	"~OOO~~~\n" ..
	"~XXXOX~\n",

	-- Column no winner
	"~~~~~~~\n" ..
	"X~~~~~~\n" ..
	"OX~~~~~\n" ..
	"XO~~~~~\n" ..
	"XO~~~~~\n" ..
	"XO~~~~~\n",

	-- Diagonal 1 no winner
	"~~~~~~~\n" ..
	"~~~~X~~\n" ..
	"~~~OX~~\n" ..
	"~~XXO~~\n" ..
	"~XOOX~~\n" ..
	"XOOXO~~\n",

	-- Diagonal 2 no winner
	"~~~~~~~\n" ..
	"X~~~~~~\n" ..
	"OX~~~~~\n" ..
	"OOX~~~~\n" ..
	"XOXO~~~\n" ..
	"OXOXX~~\n",

	-- Empty board
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~~~~\n" ..
	"~~~~~~~\n"
}

function TestConnectFour:setUp()
	self.full_board = ConnectFour.unserialize(boards[1]) --full table
	self.winner_vertical = ConnectFour.unserialize(boards[2]) --column X
	self.winner_horizontal = ConnectFour.unserialize(boards[3]) -- row X
	self.winner_diagonal_x = ConnectFour.unserialize(boards[4]) -- diagonal 1 X
	self.winner_diagonal_o = ConnectFour.unserialize(boards[5]) -- diagonal 2 O
	self.full_column = ConnectFour.unserialize(boards[6]) -- full column is_valid_move
	self.row_no_winner = ConnectFour.unserialize(boards[7]) -- row no winner
	self.column_no_winner = ConnectFour.unserialize(boards[8]) -- column no winner
	self.diagonal_1_no_winner = ConnectFour.unserialize(boards[9]) -- diagonal 1 no winner
	self.diagonal_2_no_winner = ConnectFour.unserialize(boards[10]) -- diagonal 2 no winner
	self.empty_board = ConnectFour.unserialize(boards[11])
end

function TestConnectFour:test_player()
	luaunit.assertEquals(self.full_board.player, "X")
end

function TestConnectFour:test_serialize()
	luaunit.assertEquals(self.full_board:serialize(), boards[1])
	luaunit.assertEquals(self.empty_board:serialize(), boards[11])
end

function TestConnectFour:test_unserialize()
	local two_moves = ConnectFour()
	two_moves:move("X", 1)
	two_moves:move("O", 2)

	luaunit.assertEquals(
		ConnectFour.unserialize(
			"~~~~~~~\n" ..
			"~~~~~~~\n" ..
			"~~~~~~~\n" ..
			"~~~~~~~\n" ..
			"~~~~~~~\n" ..
			"XO~~~~~\n"),
		two_moves)
end

function TestConnectFour:test_get()
	luaunit.assertEquals(self.winner_vertical:get( 5,2), "O")
	luaunit.assertEquals(self.winner_vertical:get( 4,1), "X")
	luaunit.assertEquals(self.winner_vertical:get( 3,3), nil)
end

function TestConnectFour:test_get_player()
	luaunit.assertEquals(self.empty_board:get_player(), "X")
	luaunit.assertEquals(self.diagonal_1_no_winner:get_player(), "O")
	luaunit.assertEquals(self.diagonal_2_no_winner:get_player(), "O")

	luaunit.assertNil(self.full_board:get_player())
	luaunit.assertNil(self.winner_vertical:get_player())
	luaunit.assertNil(self.winner_horizontal:get_player())
	luaunit.assertNil(self.winner_diagonal_x:get_player())
	luaunit.assertNil(self.winner_diagonal_o:get_player())
end

function TestConnectFour:test_get_current_row()
	luaunit.assertEquals(self.winner_vertical:get_current_row(1), 2)
	luaunit.assertEquals(self.winner_vertical:get_current_row(5), 6)
	luaunit.assertEquals(self.full_board:get_current_row(1), 0)
end

function TestConnectFour:test_is_valid_move()
	-- Test move order
	luaunit.assertTrue(self.empty_board:is_valid_move("X", 1))
	luaunit.assertFalse(self.empty_board:is_valid_move("O", 1))

	-- Test out of bounds
	luaunit.assertFalse(self.empty_board:is_valid_move("X", 0))
	luaunit.assertFalse(self.empty_board:is_valid_move("X", 8))

	-- Test full column
	luaunit.assertFalse(self.full_column:is_valid_move("X", 1))
	luaunit.assertFalse(self.full_board:is_valid_move("X", 1))
end

function TestConnectFour:test_get_winner()
	luaunit.assertNil(self.full_board:get_winner())
	luaunit.assertNil(self.full_column:get_winner())
	luaunit.assertNil(self.row_no_winner:get_winner())
	luaunit.assertNil(self.column_no_winner:get_winner())
	luaunit.assertNil(self.diagonal_1_no_winner:get_winner())
	luaunit.assertNil(self.diagonal_2_no_winner:get_winner())
	luaunit.assertNil(self.empty_board:get_winner())

	luaunit.assertEquals(self.winner_vertical:get_winner(), "X")
	luaunit.assertEquals(self.winner_horizontal:get_winner(), "X")
	luaunit.assertEquals(self.winner_diagonal_x:get_winner(), "X")
	luaunit.assertEquals(self.winner_diagonal_o:get_winner(), "O")
end

return TestConnectFour
