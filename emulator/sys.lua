--- System module.
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
-- @zenterio
function sys.new_timer(interval_millisec, callback)
	new_timer = timer(interval_millisec, callback)
	new_timer:start()
	table.insert(sys.timers, new_timer)

	return new_timer
end

--- Get time since program start.
-- Useful to measure lengths of time.
-- @return Time since system start in seconds with decimal precision.
-- @zenterio
function sys.time()
	return love.timer.getTime()
end


--- Terminate execution.
--
-- Terminates the execution of the script. The rest of the currently executing
-- code will be run, but all timers are stopped and the current script
-- environment will never be called again.
-- @zenterio
function sys.stop()
	-- TODO: This is probably not a correct implementation
	love.event.quit()
end

--- Get root path.
--
-- If a script was started with _sendcmd LuaEngine run_, this variable  contains
-- the path of that script, to allow finding files related to the script.
--
-- @return Path to directory where start.lua is
-- @zenterio
function sys.root_path()
	return love.filesystem.getWorkingDirectory()
end

--- Create new player.
--
-- Create a new media @{emulator.player|player} instance.
--
-- @return Player instance
-- @see emulator.player
-- @zenterio
function sys.new_player()
	local player = player()
	return player
end

--- New freetype.
--
-- Create new @{emulator.freetype|freetype} instance. This is the only was to
-- construct a freetype instance on the set-top box.
--
-- @param fontColor Color of text
-- @param fontSize Size of text
-- @param drawingStartPoint Upper left corner of first character to be drawn
-- @param fontPath Path to font. Use absolute path, for compatibility with
--                 set-top box.
-- @return Freetype instance
-- @see emulator.freetype
-- @see utils.absolute_path
-- @zenterio
function sys.new_freetype(fontColor, fontSize, drawingStartPoint, fontPath)
	local freetype = freetype(fontColor, fontSize, drawingStartPoint, fontPath)
	return freetype
end

sys.timers = {}

return sys
