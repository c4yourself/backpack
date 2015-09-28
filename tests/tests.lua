local LuaUnit = require("luaunit")

-- Enable import as if we were executing from the actual program
package.path = "../?.lua;" .. package.path

-- Make sure logging is disabled since it can interfere with the tests
local config = require("config")
config.logging.mode = "DISABLED"

-- All tests should be included from here
TestLogger = require("test_logger")
TestUtils = require("test_utils")

lu = LuaUnit.LuaUnit.new()
--lu:setOutputType("tap")
os.exit(lu:runSuite())