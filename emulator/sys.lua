--- System module
-- Part of Zenterio Lua API.
-- @module emulator.sys
-- @alias sys

local logger = require("lib.logger")
local timer = require("emulator.timer")

local sys = {}

--- Create callback timer
-- @param interval_millisec How often to call callback function in milliseconds
-- @param callback Callback function or string name of global function
-- @return @{emulator.timer|timer} instance
-- @see emulator.timer
function sys.new_timer(interval_millisec, callback)
	logger.trace("New timer created. Calling: " .. callback .. " every " .. interval_millisec)
	new_timer = timer(interval_millisec, callback)
	new_timer:start()
	table.insert(sys.timers, new_timer)
	return new_timer
end

--- Get time
-- Useful to measure lengths of time.
-- @return Time since system start in seconds with decimal precision.
function sys.time()
	return love.timer.getTime()
end


---Stop
--
-- Terminates the execution of the script. The rest of the currently executing
-- code will be run, but all timers are stopped and the current script
-- environment will never be called again.
function sys.stop()
	-- TODO: This is probably not a correct implementation
	love.event.quit()
end

--- Get Root Path
--
-- If a script was started with "sendcmd LuaEngine run", this variable  contains
-- the path of that script, to allow finding files related to the script.
--
-- @return Path where start.lua is
function sys.root_path()
	return love.filesystem.getUserDirectory()
end

--- Create new player
-- Create a new media @{emulator.player|player} instance.
--
-- @return Player instance
-- @see emulator.player
function sys.new_player()
	local player = player()
	return player
end

--- New freetype
--
-- Create new @{emulator.freetype|freetype} instance, which draw a text on the
-- surface. Font -- parameters: color, size, and path to .ttf file are a input
-- arguments. Argument <drawingStartPoint> is a left upper corner a start point
-- to a drawing text.
--
-- @return Freetype instance
-- @see emulator.freetype
function sys.new_freetype(fontColor, fontSize, drawingStartPoint, fontPath)
	local freetype = freetype(fontColor, fontSize, drawingStartPoint, fontPath)
	return freetype
end

sys.timers = {}

return sys
