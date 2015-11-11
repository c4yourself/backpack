--- Player mock class
local class = require("lib.classy")
local PlayerMock = class("PlayerMock")

-- Attributes initialized
local aspect_ratio
local current_url
local eos_callback
local player_windows
-- State = 4 means playing and state = 0 means stopped
local state

-- Return status
function PlayerMock:get_state(url)
	return state
end

-- Set current_uml to given uml and change state to playing
function PlayerMock:play_url(url)
	current_url = url
	state = 4
end

-- set aspect_ratio to the given aspect ratio
function PlayerMock:set_aspect_ratio(aspect_ratio)
	self.aspect_ratio = aspect_ratio
end

-- set eos_callback to the given callback
function PlayerMock:set_on_eos_pseudocallback(callback)
	self.eos_callback = callback
end

-- save arguments into player_window
function PlayerMock:set_player_window(x, y, width, height, refW, refH)
	player_window = {}
	player_window["x"] = x
	player_window["y"] = y
	player_window["width"] = width
	player_window["height"] = height
	player_window["refW"] = refW
	player_window["refH"] = refH
end

-- change state to stopped
function PlayerMock:stop()
	state = 0
end

return PlayerMock
