local class = require("lib.classy")
local luaunit = require("luaunit")
local Item = require("lib.store.Item")

local TestItem = {}

function TestItem:setUp()
	TestItem.item = Item("5", "Fredrik", "Stockholm", "best", "nothing", "1337")
end

function TestItem:test_get_id()
	luaunit.assertEquals(TestItem.item:get_id(), "5")
end

function TestItem:test_get_name()
	luaunit.assertEquals(TestItem.item:get_name(), "Fredrik")
end

function TestItem:test_get_city()
	luaunit.assertEquals(TestItem.item:get_city(), "Stockholm")
end

function TestItem:test_get_description()
	luaunit.assertEquals(TestItem.item:get_description(), "best")
end

function TestItem:test_get_image_path()
	luaunit.assertEquals(TestItem.item:get_image_path(), "nothing")
end

function TestItem:test_get_price()
	luaunit.assertEquals(TestItem.item:get_price(), "1337")
end

return TestItem
