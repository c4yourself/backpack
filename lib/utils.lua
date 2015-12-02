--- Collection of useful functions
-- @module utils

local config = require("config")

local utils = {}

--- Convert a path to an absolute path relative to the program root
-- The returned path is canonical. Useful since working directory behaves
-- differently on emulator compared to set-top box.
--
-- @param path Path to convert
-- @return Absolute path relative to root path
-- @see emulator.sys.root_path
function utils.absolute_path(path)
	local absolute_path = path
	if path:sub(1, 1) ~= "/" and not config.is_emulator then
		absolute_path = sys.root_path() .. "/" .. absolute_path
	end

	return utils.canonicalize_path(absolute_path)
end

--- Convert any path to a normalized canonical form
-- @param path Path to convert
-- @return Canonicalized path
function utils.canonicalize_path(path)
	local output = {}
	local is_absolute = path:sub(1, 1) == "/"

	for i, part in ipairs(utils.split(path, "/")) do
		if part == "." or part == "" then
			-- Ignore
		elseif part == ".." then
			if #output == 0 or output[#output] == ".." then
				if not is_absolute then
					table.insert(output, "..")
				end
			else
				table.remove(output)
			end
		else
			table.insert(output, part)
		end
	end

	if is_absolute then
		table.insert(output, 1, "")
	end

	return table.concat(output, "/")
end

--- Delay a function call to given number of milliseconds after this call.
-- Does not block execution.
-- @param delay Delay in milliseconds before firing callback
-- @param callback Callback to run
-- @return Created @{emulator.timer} instance
function utils.delay(delay, callback)
	local timer
	timer = sys.new_timer(delay, function()
		callback()
		timer:stop()
	end)
	timer:start()
end

--- Extract table keys.
-- @param input_table Table to extract keys from
-- @return A table containing keys of input_table
function utils.keys(input_table)
	local output = {}

	for key, _ in pairs(input_table) do
		table.insert(output, key)
	end

	return output
end

--- Wrap function with partial application of the given arguments and keywords.
-- This is an implementation of function currying. This function is mostly used
-- when binding class instance methods to Event class instances.
--
-- @param func Function to wrap
-- @param[opt] ...  Default arguments that will be passed to the wrapped function
-- @return A wrapper function that applies the given function function arguments
--
-- @usage
-- local class_instance = SampleClass()
-- local method = utils.partial(class_instance.method, class_instance)(1, 2, 3)
--
-- -- The following are the same
-- class_instance:method(1, 2, 3) == method(1, 2, 3)
function utils.partial(func, ...)
	-- Default arguments
	local curry = {...}

	function wrapper(...)
		-- Arguments from this function call
		local args = {...}

		-- Final arguments list
		local call_args = {}

		-- Apply default arguments
		for i = 1, #curry do
			table.insert(call_args, curry[i])
		end

		-- Apply the arguments from this call
		for i = 1, #args do
			table.insert(call_args, args[i])
		end

		return func(unpack(call_args))
	end

	return wrapper
end

--- Split string into a table of parts
-- @param str String to split into parts
-- @param[opt=""] delimiter String to split at
-- @return Table of parts that were separated by delimiter
function utils.split(str, delimiter)
	local output = {}

	if delimiter == nil then
		delimiter = ""
	end

	local i = 1
	local current = ""
	while i <= #str do
		if delimiter == "" then
			table.insert(output, str:sub(i, i))
			current = ""
			i = i + 1
		elseif str:sub(i, i + #delimiter - 1) == delimiter then
			table.insert(output, current)
			current = ""

			i = i + #delimiter
		else
			current = current .. str:sub(i, i)
			i = i + 1
		end
	end

	if delimiter ~= "" then
		table.insert(output, current)
	end

	return output
end

function utils.to_base(number, base)
	base = base or 10
	is_negative = number < 0
	number = math.abs(number)

	local base_characters = utils.split("0123456789abcdef")

	if base > #base_characters or base < 2 then
		error("Base out of range")
	elseif number ~= math.floor(number) then
		error("Only integer numbers supported")
	end

	local digits = {}
	repeat
		table.insert(digits, base_characters[(number % base) + 1])
		number = math.floor(number / base)
	until number == 0

	return (is_negative and "-" or "") .. table.concat(digits):reverse()
end

return utils
