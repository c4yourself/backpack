local luaunit = require("luaunit")
local class = require("lib.classy")
local Country = require("lib.city.Country")

local TestCountry = {}

--Set up a country
function TestCountry:setUp()
	TestCountry.country = Country("A name", "A code", "currency format", "exchange rate")
end

--Check that it got initalised properly
function TestCountry:test_init()
	luaunit.assertNotNil(TestCountry.country)
	luaunit.assertEquals(TestCountry.country.name, "A name")
	luaunit.assertEquals(TestCountry.country.country_code, "A code")
	luaunit.assertEquals(TestCountry.country.currency_format, "currency format")
	luaunit.assertEquals(TestCountry.country.exchange_rate, "exchange rate")
end

return TestCountry
