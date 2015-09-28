--- Dummy logger to be used when no logging is desired.
-- Inherits from @{Logger}
-- @classmod DummyLogger

local class = require("lib.classy")
local Logger = require("lib.logger.Logger")

local DummyLogger = class("DummyLogger", Logger)

--- @local
function DummyLogger:_write(message, obj) end

return DummyLogger
