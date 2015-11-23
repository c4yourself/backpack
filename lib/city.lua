--- Event module
-- @module event
local city = {}

city.City = require("lib.city.City")
city.Country = require("lib.city.Country")

-- Init each country
city.country = {france = city.Country("France", "FRA", "%.2f €", nil, 1),
                egypt = city.Country("Egypt", "EGY", "%.2f ج.م", nil, 1)}

city.cities = {paris = city.City("paris", "Paris", city.country.france, nil),
              cairo = city.City("cairo", "Cairo", city.country.egypt, nil)}

return city
