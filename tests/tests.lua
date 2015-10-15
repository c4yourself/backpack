local LuaUnit = require("luaunit")

-- Enable import as if we were executing from the actual program
package.path = "../?.lua;" .. package.path

-- Make sure logging is disabled since it can interfere with the tests
local config = require("config")
config.logging.mode = "DISABLED"

-- All tests should be included from here
TestEvent = require("test_event")
TestLogger = require("test_logger")
TestUtils = require("test_utils")
TestView = require("test_view_View")
TestViewManager = require("test_view_ViewManager")



lu = LuaUnit.LuaUnit.new()
lu:setOutputType("tap")
os.exit(lu:runSuite())
