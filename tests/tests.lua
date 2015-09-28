local LuaUnit = require("luaunit")

-- Enable import as if we were executing from the actual program
package.path = "../?.lua;" .. package.path

-- All tests should be included from here
TestLogger = require("test_logger")

lu = LuaUnit.LuaUnit.new()
--lu:setOutputType("tap")
os.exit(lu:runSuite())
