local luaunit = require("luaunit")
local color = require("lib.color")

local TestColor = {}

function TestColor:test_default_values()
	local color = color.Color()

	luaunit.assertEquals(color.red, 0)
	luaunit.assertEquals(color.green, 0)
	luaunit.assertEquals(color.blue, 0)
	luaunit.assertEquals(color.alpha, 255)
end

function TestColor:test_to_table()
	luaunit.assertEquals(color.Color():to_table(), {0, 0, 0, 255})
	luaunit.assertEquals(color.Color(1, 2, 3, 4):to_table(), {1, 2, 3, 4})
end

function TestColor:test_from_html()
	luaunit.assertEquals(
		color.Color.from_html("#fff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		color.Color.from_html("#ffff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		color.Color.from_html("#ffffff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		color.Color.from_html("#ffffffff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		color.Color.from_html("ffffffff"):to_table(), {255, 255, 255, 255})

	luaunit.assertError(color.Color.from_html, "#ffg")
end

function TestColor:test_to_number()
	luaunit.assertEquals(color.Color(255, 255, 255, 255):to_number(), 4294967295)
end

return TestColor
