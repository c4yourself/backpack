--- Player mock class
local class = require("lib.classy")
local FreetypeMock = require("lib.mocks.FreetypeMock")
local SysMock = class("SysMock")


--local logger = require("lib.logger")
--local timer = require("emulator.timer")

-- Attributes initialized
local system_time = 2355

--local sys = {}

-- returns a mock freetype
function SysMock.new_freetype(fontColor, fontSize, drawingStartPoint, fontPath)
	local freetype = FreetypeMock(fontColor, fontSize, drawingStartPoint, fontPath)
	return freetype
end

-- return a number representing a time
function SysMock.time()
	return system_time
end

-- returns a mock player
function SysMock.new_player()
	local player = PlayerMock()
	return player
end

-- returns a mock timer
function SysMock.new_timer(interval_millisec, callback)
--TODO
--[[	logger.trace(string.format(
		"New timer created, calling every %d ms",
		interval_millisec))

	new_timer = timer(interval_millisec, callback)
	new_timer:start()
	table.insert(sys.timers, new_timer)
	return new_timer]]
end

-- return the absolute path to the directory where start.lua is located
function SysMock.root_path()
--TODO
	--return love.filesystem.getUserDirectory()
end

-- terminate the lua interpreter
function SysMock.stop()
	-- TODO
	--love.event.quit()
end

--sys.timers = {}

return sys
