local luaunit = require("luaunit")
local draw = require("lib.draw")

local TestColor = {}

function TestColor:test_default_values()
	local color = draw.Color()

	luaunit.assertEquals(color.red, 0)
	luaunit.assertEquals(color.green, 0)
	luaunit.assertEquals(color.blue, 0)
	luaunit.assertEquals(color.alpha, 255)
end

function TestColor:test_from_html()
	luaunit.assertEquals(
		draw.Color.from_html("#fff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		draw.Color.from_html("#ffff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		draw.Color.from_html("#ffffff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		draw.Color.from_html("#ffffffff"):to_table(), {255, 255, 255, 255})
	luaunit.assertEquals(
		draw.Color.from_html("ffffffff"):to_table(), {255, 255, 255, 255})

	luaunit.assertError(draw.Color.from_html, "#ffg")
end

function TestColor:test_from_table()
	luaunit.assertEquals(
		draw.Color.from_table({}):to_table(),
		{0, 0, 0, 255})
	luaunit.assertEquals(
		draw.Color.from_table({255, 255, 255}):to_table(),
		{255, 255, 255, 255})
	luaunit.assertEquals(
		draw.Color.from_table({255, 255, 255, 255}):to_table(),
		{255, 255, 255, 255})
	luaunit.assertEquals(
		draw.Color.from_table({r=255, g=255, b=255, a=255}):to_table(),
		{255, 255, 255, 255})
	luaunit.assertEquals(
		draw.Color.from_table({red=255, green=255, blue=255, alpha=255}):to_table(),
		{255, 255, 255, 255})

	luaunit.assertError(draw.Color.from_table, 1)
	luaunit.assertError(draw.Color.from_table, {grue=255})
end

function TestColor:test_to_html()
	luaunit.assertEquals(draw.Color(255, 255, 255, 255):to_html(), "#ffffff")
	luaunit.assertEquals(draw.Color(255, 255, 255, 0):to_html(), "#ffffff00")
end

function TestColor:test_to_number()
	luaunit.assertEquals(draw.Color(255, 255, 255, 255):to_number(), 4294967295)
end

function TestColor:test_to_table()
	luaunit.assertEquals(draw.Color():to_table(), {0, 0, 0, 255})
	luaunit.assertEquals(draw.Color(1, 2, 3, 4):to_table(), {1, 2, 3, 4})
end

return TestColor
