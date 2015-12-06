local luaunit = require ("luaunit")
local rectangle = require("lib.draw.Rectangle")

local TestRectangle = {}

local x = 1
local y = 2
local width = 3
local height = 4

function TestRectangle:setUp()
	TestRectangle.rect = rectangle(x, y, width, height)
end

function TestRectangle:test_get_start()
	luaunit.assertEquals({TestRectangle.rect:get_start()}, {x, y})
end

function TestRectangle:test_get_end()
	luaunit.assertEquals({TestRectangle.rect:get_end()}, {x + width - 1, y + height - 1} )
end

function TestRectangle:test_contains()
	local small_rect = rectangle(x, y, width, height)
	luaunit.assertEquals(TestRectangle.rect:contains(small_rect), true)

	local large_rect = rectangle(0, 0, width, height)
	luaunit.assertEquals(TestRectangle.rect:contains(large_rect), false)
end

function TestRectangle:test_to_table()
	luaunit.assertEquals(TestRectangle.rect:to_table(), {x = x, y = y, width = width, height = height})
end

return TestRectangle
