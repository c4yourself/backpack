--- Player mock class
local class = require("lib.classy")
local FreetypeMock = require("lib.mocks.FreetypeMock")
local PlayerMock = require("lib.mocks.PlayerMock")
local TimerMock = require("lib.mocks.TimerMock")
local utils = require("lib.utils")
local SysMock = class("SysMock")

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
	time = TimerMock()
	return time
end

-- return the absolute path to the directory where start.lua is located
function SysMock.root_path()
	return utils.absolute_path("/")
--TODO
end

-- terminate the lua interpreter
function SysMock.stop()
	sys.stop()
	-- TODO Make it better, faster, stronger and a bit harder maybe
	--love.event.quit()
end

--sys.timers = {}

return SysMock
