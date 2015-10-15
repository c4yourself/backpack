local class = require("lib.classy")
local luaunit = require("luaunit")
local logger = require("lib.logger")

-- Implement a custom logging class that logs everything to an internal string
local StringLogger = class("StringLogger", logger.Logger)

function StringLogger:_write(message, obj)
	if self.data == nil then
		self.data = ""
	end

	-- obj is ignored for now
	self.data = self.data .. message .. "\n"
end

local TestLogger = {}

function TestLogger:setUp()
	self.logger = StringLogger()
end

-- Test that default values are set to expected values
function TestLogger:test_defaults()
	luaunit.assertEquals(self.logger.level, "WARN")
	luaunit.assertFalse(self.logger.log_memory)
end

-- Test to break jenkins
function TestLogger:test_break()
	luaunit.assertFalse(true)
end


-- Test that log level is respected
function TestLogger:test_level()
	self.logger:trace("TEST 1")
	luaunit.assertNil(self.logger.data)

	self.logger:debug("TEST 2")
	luaunit.assertNil(self.logger.data)

	self.logger:warn("TEST 3")
	luaunit.assertStrContains(self.logger.data, "TEST 3")

	self.logger:error("TEST 4")
	luaunit.assertStrContains(self.logger.data, "TEST 4")
end

function TestLogger:test_level_isolation()
	luaunit.assertEquals(self.logger.level, logger.Logger.level)
	self.logger.level = "TRACE"
	luaunit.assertEquals(logger.Logger.level, "WARN")
end

-- Make sure that UDPLogger is not available when LuaSocket is not
function TestLogger:test_udp_error_on_no_lua_socket()
	luaunit.assertNotNil(logger.UDPLogger)
	luaunit.assertError(logger.UDPLogger)
end

return TestLogger
