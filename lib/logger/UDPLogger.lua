--- Logger that sends statemets to a given UDP listener.
-- Inherits from @{Logger}. Only available when LuaSocket is.
-- @classmod UDPLogger

-- Standard Lua (used by test suite) does not have LuaSocket. Hence the require
-- is done with a pcall(), and UDPLogger will only be available if the LuaSocket
-- module is

local class = require("lib.classy")
local Logger = require("lib.logger.Logger")
local serpent = require("lib.serpent")
local has_socket, socket = pcall(require, "socket")

local UDPLogger = function()
	error("LuaSocket not available")
end

if has_socket then
	UDPLogger = class("UDPLogger", Logger)

	--- Constructor for UDPLogger
	-- @param ip_address IP-address of UDP listener
	-- @param port Port that UDP listener listens on
	-- @param level Log level as capitalized string
	-- @param log_memory Boolean flag to whether to log memory usage or not
	-- @raise Error if called without LuaSocket being available
	function UDPLogger:__init(ip_address, port, level, log_memory)
		Logger.__init(self, level, log_memory)

		self.udp = socket.udp()
		self.udp.settimeout(0)
		self.udp.setpeername(ip_address, port)
	end

	--- @local
	function UDPLogger:_write(message, obj)
		self.udp:send(message)
		if obj ~= nil then
			self.udp:send("               " .. serpent.line(obj))
		end
	end
end

return UDPLogger
