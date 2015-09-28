--- Media player implementation
-- @classmod emulator.player
-- @alias player

local class = require("lib.classy")

local player = class("player")

--- Play URL
--
-- Start playback a video context from <url>. URL should meet the requirements
-- of the specification.
--
-- The specification is unknown.
--
-- @param url URL for media
function player:play_url(url)
	self.url = url
	self.state = 4
end

--- Stop playback
-- Stop playback a video (player switches to 0 state)
function player:stop()
	self.state = 0
end

--- Bind callback for when media reaches end of stream
-- @param callback Callback to run at end of stream
function player:set_on_eos_pseudocallback(callback)
	self.cb = callback
end

--- Get state
-- State of player; 0 means stopped, 4 means playing
-- @return state Current state of media playback
function player:get_state()
	return self.state
end

--- Set aspect ratio
--
-- Set aspect ratio for video context. Details on this functions are unknown.
--
-- @param aspect_ratio Numeric representation of aspect ratio
function player:set_aspect_ratio(aspect_ratio)
	self.aspect_ratio = aspect_ratio
end

--- Set player window position and size
--
-- If refW and refH are set to 100. All other parameters are interpreted in
-- percent instead of pixels.
--
-- @param x X position of top left corner (starts at 0)
-- @param y Y position of top left corner (starts at 0)
-- @param width Width in pixels of window
-- @param height Height in pixels of window
-- @param refW Reference width of screen
-- @param refH Reference height of screen
function player:set_player_window(x, y, width, height, refW, refH)
	self.x = x or 0
	self.y = y or 0
	self.width = width or 1280
	self.height = height or 720
	self.refW = refW or 100
	self.refH = refH or 100
end

return player
