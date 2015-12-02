--- Timer implementation used by emulation.
--
-- Calls a given callback function every given interval. Must be constructed
-- using @{emulator.sys.new_timer|sys.new_timer}. Callback function will be
-- called with timer as its only argument.
--
-- @classmod emulator.timer
-- @alias timer

local class = require("lib.classy")
local logger = require("lib.logger")

local timer = class("timer")

--- Construct a new timer
-- @param interval_millisec How often to call callback function in milliseconds
-- @param callback Callback function
-- @see emulator.sys.new_timer
-- @local
function timer:__init(interval_millisec, callback)
	logger.trace(string.format(
		"New timer created %s, calling every %d ms",
		tostring(self):sub(8),
		interval_millisec))

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
	logger.trace("Stopping timer " .. tostring(self):sub(8))
	self.running = false
	self.time_since = 0
end

--- Start timer.
-- The timer starts generating callbacks at the prescribed interval, if
-- previously stopped.
-- @zenterio
function timer:start()
	logger.trace("Starting timer " .. tostring(self):sub(8))
	self.running = true
	self.time_since = 0
end

--- Update time passed since last update.
-- @param delta_time Time passed since last check
function timer:_update_time(delta_time)
	self.time_since = self.time_since + delta_time
end

---
-- @local
function timer:_is_ready()
	return self.running and self.time_since >= self.interval_millisec
end

---
-- @local
function timer:_fire()
	logger.trace("Firing timer " .. tostring(self):sub(8), self.time_since)
	if type(self.callback) == "function" then
		self.callback()
	elseif type(self.callback) == "string" then
		local callback = loadstring(self.callback .. "()")
		callback()
	end
	self.time_since = 0
end

return timer
