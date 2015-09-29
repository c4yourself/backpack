--- Collection of useful functions
-- @module utils

local utils = {}

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

--- Convert a path to an absolute path relative to the program root
-- The returned path is canonical. Useful since working directory behaves
-- differently on emulator compared to set-top box.
--
-- @param path Path to convert
-- @return Absolute path relative to root path
-- @see emulator.sys.root_path
function utils.absolute_path(path)
	local absolute_path = path
	if path:sub(1, 1) ~= "/" then
		absolute_path = sys.root_path() .. "/" .. absolute_path
	end

	return utils.canonicalize_path(path)
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

return utils
