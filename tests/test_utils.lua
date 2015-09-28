local luaunit = require("luaunit")
local utils = require("lib.utils")

local TestUtils = {}

function TestUtils:test_split_no_delimiter()
	luaunit.assertEquals(utils.split("test"), {"t", "e", "s", "t"})
	luaunit.assertEquals(utils.split("foo"), {"f", "o", "o"})
	luaunit.assertEquals(utils.split("bar"), {"b", "a", "r"})
end

function TestUtils:test_split()
	luaunit.assertEquals(utils.split("123", " "), {"123"})
	luaunit.assertEquals(utils.split("1 2 3", " "), {"1", "2", "3"})
	luaunit.assertEquals(utils.split("4 5 6", " "), {"4", "5", "6"})
end

function TestUtils:test_split_multi_char_delimiter()
	luaunit.assertEquals(utils.split("1, 2, 3", ", "), {"1", "2", "3"})
	luaunit.assertEquals(utils.split("4, 5, 6", ", "), {"4", "5", "6"})
end

function TestUtils:test_canonicalize_path()
	luaunit.assertEquals(utils.canonicalize_path("./test"), "test")
	luaunit.assertEquals(utils.canonicalize_path("../test"), "../test")
	luaunit.assertEquals(utils.canonicalize_path("/test"), "/test")

	luaunit.assertEquals(utils.canonicalize_path("/test//test"), "/test/test")
	luaunit.assertEquals(utils.canonicalize_path("test//test"), "test/test")

	luaunit.assertEquals(utils.canonicalize_path("./test/../test"), "test")
	luaunit.assertEquals(utils.canonicalize_path("/../test"), "/test")
end

return TestUtils
