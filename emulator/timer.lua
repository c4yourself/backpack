--- Timer implementation used by emulation.
--
-- Calls a given callback function every given interval. Must be constructed
-- using @{emulator.sys.new_timer|sys.new_timer}. Callback function will be
-- called with timer as its only argument.
--
-- @classmod emulator.timer
-- @alias timer

local class = require("lib.classy")

local timer = class("timer")

--- Construct a new timer
-- @param interval_millisec How often to call callback function in milliseconds
-- @param callback Callback function
-- @see emulator.sys.new_timer
-- @local
function timer:__init(interval_millisec, callback)
	self.interval_millisec = interval_millisec
	self.callback = callback
	self.running = false
	self.time_since = 0
end

--- Change callback interval
-- @param interval_millisec How often to call callback function in milliseconds
-- @zenterio
function timer:set_interval(interval_millisec)
	self.interval_millisec = interval_millisec
end

--- Stop timer.
-- No more callbacks are generated, even if a timer timeout already happened and
-- was waiting for dispatching.
-- @zenterio
function timer:stop()
	self.running = false
	self.time_since = 0
end

--- Start timer.
-- The timer starts generating callbacks at the prescribed interval, if
-- previously stopped.
-- @zenterio
function timer:start()
	self.running = true
end

return timer
