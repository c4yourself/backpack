local luaunit = require("luaunit")
local utils = require("lib.utils")

local TestUtils = {}

function TestUtils:test_canonicalize_path()
	luaunit.assertEquals(utils.canonicalize_path("./test"), "test")
	luaunit.assertEquals(utils.canonicalize_path("../test"), "../test")
	luaunit.assertEquals(utils.canonicalize_path("/test"), "/test")

	luaunit.assertEquals(utils.canonicalize_path("/test//test"), "/test/test")
	luaunit.assertEquals(utils.canonicalize_path("test//test"), "test/test")

	luaunit.assertEquals(utils.canonicalize_path("./test/../test"), "test")
	luaunit.assertEquals(utils.canonicalize_path("/../test"), "/test")
end

function TestUtils:test_keys()
	luaunit.assertItemsEquals(utils.keys({a = 1, b = 2}), {"a", "b"})
	luaunit.assertItemsEquals(utils.keys({c = 1, d = 2}), {"c", "d"})
end

function TestUtils:test_partial()
	local tuple = function(...) return {...} end

	luaunit.assertEquals(utils.partial(tuple, 1)(), {1})
	luaunit.assertEquals(utils.partial(tuple, 1, 2)(), {1, 2})
	luaunit.assertEquals(utils.partial(tuple, 1, 2, 3)(), {1, 2, 3})

	luaunit.assertEquals(utils.partial(tuple)(1, 2, 3), {1, 2, 3})
	luaunit.assertEquals(utils.partial(tuple, 1)(2, 3), {1, 2, 3})
	luaunit.assertEquals(utils.partial(tuple, 1, 2)(3), {1, 2, 3})
end

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

function TestUtils:test_to_base()
	luaunit.assertEquals(utils.to_base(100), "100")
	luaunit.assertEquals(utils.to_base(1337), "1337")
	luaunit.assertEquals(utils.to_base(10, 2), "1010")
	luaunit.assertEquals(utils.to_base(10, 8), "12")
	luaunit.assertEquals(utils.to_base(10, 16), "a")
	luaunit.assertEquals(utils.to_base(15, 16), "f")
	luaunit.assertEquals(utils.to_base(16, 16), "10")
	luaunit.assertEquals(utils.to_base(255, 16), "ff")


	luaunit.assertEquals(utils.to_base(-100), "-100")
	luaunit.assertEquals(utils.to_base(-10, 16), "-a")

	luaunit.assertError(utils.to_base, 100, -1)
	luaunit.assertError(utils.to_base, 100, 17)
	luaunit.assertError(utils.to_base, 3.14)
end

return TestUtils
