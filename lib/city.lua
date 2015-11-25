
-- @module city
local city = {}

city.City = require("lib.city.City")
city.Country = require("lib.city.Country")

-- Init each country
city.country = {france = city.Country("France", "FRA", "%.2f €", nil, 1),
                egypt = city.Country("Egypt", "EGY", "%.2f ج.م", nil, 1)}

city.cities = {

  paris = city.City("paris", "Paris", city.country.france, {
    {"london", "boat", 1000},
    {"london", "plane", 2000},
    {"bombay", "plane", 6000},
    {"bombay", "train", 4000},
    {"rio_de_janeiro", "plane", 5500}
  }),

  cairo = city.City("cairo", "Cairo", city.country.egypt, {
    {"bombay", "plane", 3000},
    {"london", "plane", 2000},
    {"tokyo", "plane", 6000},
    {"rio_de_janeiro", "plane", 5000}
  }),

  london = city.City("london", "London", city.country.london, {
    {"paris", "boat", 1000},
    {"paris", "plane", 2000},
    {"new_york", "plane", 6000},
    {"new_york", "boat", 4000},
    {"cairo", "plane", 5000}
  }),

  bombay = city.City("bombay", "Bombay", city.country.bombay, {
    {"paris", "plane", 6000},
    {"paris", "train", 4000},
    {"sydney", "plane", 7500},
    {"cairo", "plane", 3000}
  }),

  new_york = city.City("new_york", "New York", city.country.new_york, {
    {"london", "boat", 4000},
    {"london", "plane", 6000},
    {"rio", "plane", 5000},
    {"tokyo", "plane", 8000},
  }),

  rio_de_janeiro = city.City("rio_de_janeiro", "Rio de Janeiro", city.country.rio_de_janeiro, {
    {"new_york", "boat", 5000},
    {"paris", "plane", 5500},
    {"sydney", "plane", 4000},
    {"cairo", "plane", 5000}
  }),

  tokyo = city.City("tokyo", "Tokyo", city.country.tokyo, {
    {"sydney", "boat", 3000},
    {"sydney", "plane", 5000},
    {"new_york", "plane", 8000},
    {"cairo", "plane", 6000}
  }),

  sydney = city.City("sydney", "Sydney", city.country.sydney, {
    {"tokyo", "boat", 3000},
    {"tokyo", "plane", 5000},
    {"bombay", "plane", 7500},
    {"rio", "plane", 4000}
  }),


}

return city
