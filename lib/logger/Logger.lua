--- Base class for loggers
-- @classmod Logger
-- @field level Current logging level
-- @field log_memory True if memory usage is logged
-- @field levels Lookup table for level names to numeric priority

local class = require("lib.classy")

local Logger = class("Logger")

Logger.level = "WARN"

Logger.log_memory = false

Logger.levels = {
	TRACE = 0,
	DEBUG = 1,
	WARN = 2,
	ERROR = 3,
	OFF = 4
}

--- Constructor for loggers
-- Will never be called directly, but useful to be called from subclasses
-- @param level Log level as capitalized string
-- @param log_memory Boolean flag to whether to log memory usage or not
function Logger:__init(level, log_memory)
	if level ~= nil then
		self.level = level
	end

	if log_memory ~= nil then
		self.log_memory = log_memory
	end
end

function Logger:_write(message, obj)
	error("_write not overloaded")
end

function Logger:_lookup_level(level)
	return self.levels[level]
end

--- Print a logging statement
-- @param level Log level as capitalized string
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function Logger:print(level, message, obj)
	-- Determine name of calling function
	local calling_function = debug.getinfo(3)
	if calling_function and calling_function.name then
		calling_function = calling_function.name
	else
		calling_function = "Anonymous"
	end

	-- Make string for memory logging if needed
	local memory_message = ""
	if self.log_memory then
		memory_message = string.format(
			" %d[%d]", gfx.get_memory_use(), gfx.get_memory_limit())
	end

	if self.levels[self.level] <= self.levels[level] then
		local output_text = string.format(
			"%s %s %s: %s%s",
			os.date("%H:%M:%S"),
			level,
			calling_function,
			message,
			memory_message)

		self:_write(output_text, obj)
	end
end

--- Make a TRACE level logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function Logger:trace(message, obj)
	self:print("TRACE", message, obj)
end

--- Make a DEBUG level logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function Logger:debug(message, obj)
	self:print("DEBUG", message, obj)
end

--- Make a WARN level logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function Logger:warn(message, obj)
	self:print("WARN", message, obj)
end

--- Make a ERROR level logging statement
-- @param message Message to write with row
-- @param obj Object to serialize as the second row
function Logger:error(message, obj)
	self:print("ERROR", message, obj)
end

return Logger
