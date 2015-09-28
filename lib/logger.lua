--- Logging module. Module level logging functions depend on the config objet
-- @module logger

-- Config file used for setting up the default logger
local config = require("config")

-- Module table
local logger = {}

--- @{Logger} base class
logger.Logger = require("lib.logger.Logger")

--- @{ConsoleLogger} class
logger.ConsoleLogger = require("lib.logger.ConsoleLogger")

--- @{DummyLogger} class
logger.DummyLogger = require("lib.logger.DummyLogger")

--- @{UDPLogger} class
logger.UDPLogger = require("lib.logger.UDPLogger")


-- Setup the default global logger
if config.logging.mode == "UDP" then
	logger.global_logger = logger.UDPLogger(
		config.logging.listener[1],
		config.logging.listener[2],
		config.logging.level,
		config.logging.log_memory)
elseif config.logging.mode == "CONSOLE" then
	logger.global_logger = logger.ConsoleLogger(
		config.logging.level,
		config.logging.log_memory)
else
	logger.global_logger = logger.DummyLogger(
		config.logging.level,
		config.logging.log_memory)
end

--- Make a TRACE level global logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function logger.trace(message, obj)
	logger.global_logger:trace(message, obj)
end

--- Make a DEBUG level global logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function logger.debug(message, obj)
	logger.global_logger:debug(message, obj)
end

--- Make a WARN level global logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function logger.warn(message, obj)
	logger.global_logger:warn(message, obj)
end

--- Make a ERROR level global logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function logger.error(message, obj)
	logger.global_logger:error(message, obj)
end

return logger
