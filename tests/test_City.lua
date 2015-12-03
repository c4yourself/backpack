local luaunit = require("luaunit")
local class = require("lib.classy")
local City = require("lib.city.City")

local TestCity = {}

--Set up a city
function TestCity:setUp()
	TestCity.city = City("something", "a name", "Sweden", "no one cares")
end

--Check that it got initalised properly
function TestCity:test_init()
	luaunit.assertNotNil(TestCity.city)
	luaunit.assertEquals(TestCity.city.code, "something")
	luaunit.assertEquals(TestCity.city.name, "a name")
	luaunit.assertEquals(TestCity.city.country, "Sweden")
	luaunit.assertEquals(TestCity.city.travel_routes, "no one cares")
end

return TestCity
