-- Timer mock class

local class = require("lib.classy")
local TimerMock = class("TimerMock")


-- Does nothing, but needed for feature parity with the regular surface class
function TimerMock:set_interval(interval_millisec)
end

-- Does nothing, but needed for feature parity with the regular surface class
function TimerMock:start()
end

-- Does nothing, but needed for feature parity with the regular surface class
function TimerMock:stop()
end

return TimerMock
