local class = require("lib.classy")
local TimerMock = require("lib.mocks.TimerMock")

local TestTimerMock = {}

-- Tests that the methods works. None of the methods does anything.
function TestTimerMock:test_methods()
	TimerMock:set_interval(10)
	TimerMock:start()
	TimerMock:stop()
end

return TestTimerMock
