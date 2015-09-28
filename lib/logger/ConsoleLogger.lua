--- Logger that prints to STDOUT.
-- Inherits from @{Logger}
-- @classmod ConsoleLogger

local class = require("lib.classy")
local Logger = require("lib.logger.Logger")
local serpent = require("lib.serpent")

local ConsoleLogger = class("ConsoleLogger", Logger)

--- Constructor for ConsoleLogger
-- @param level Log level as capitalized string
-- @param log_memory Boolean flag to whether to log memory usage or not
function ConsoleLogger:__init(level, log_memory)
	Logger.__init(self, level, log_memory)
end

--- @local
function ConsoleLogger:_write(message, obj)
	print(message)
	if obj ~= nil then
		print("               " .. serpent.line(obj))
	end
end

return ConsoleLogger
