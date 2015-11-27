--- City and country related classes and instances.
-- @module city
local city = {}

city.City = require("lib.city.City")
city.Country = require("lib.city.Country")

-- Init each country
city.countries = {
	aus = city.Country("Australia", "aus", "A$%.2f", 0.16),
	bra = city.Country("Brazil", "bra", "R$%.2f", 0.43),
	egy = city.Country("Egypt", "egy", "%.2f ج.م", 0.9),
	fra = city.Country("France", "fra", "%.2f €", 0.11),
	ind = city.Country("India", "ind", "₹%.2f", 7.6),
	jpn = city.Country("Japan", "jpn", "¥%.2f", 14),
	gbr = city.Country("United Kingdom", "gbr", "£%.2f", 0.08),
	usa = city.Country("United States", "usa", "$%.2f", 0.12),
}

city.cities = {
	paris = city.City("paris", "Paris", city.countries.fra, {
		{"london", "boat", 1000},
		{"london", "plane", 2000},
		{"bombay", "plane", 6000},
		{"bombay", "train", 4000},
		{"rio_de_janeiro", "plane", 5500}
	}),

	cairo = city.City("cairo", "Cairo", city.countries.egy, {
		{"bombay", "plane", 3000},
		{"london", "plane", 2000},
		{"tokyo", "plane", 6000},
		{"rio_de_janeiro", "plane", 5000}
	}),

	london = city.City("london", "London", city.countries.gbr, {
		{"paris", "boat", 1000},
		{"paris", "plane", 2000},
		{"new_york", "plane", 6000},
		{"new_york", "boat", 4000},
		{"cairo", "plane", 5000}
	}),

	bombay = city.City("bombay", "Bombay", city.countries.ind, {
		{"paris", "plane", 6000},
		{"paris", "train", 4000},
		{"sydney", "plane", 7500},
		{"cairo", "plane", 3000}
	}),

	new_york = city.City("new_york", "New York", city.countries.usa, {
		{"london", "boat", 4000},
		{"london", "plane", 6000},
		{"rio", "plane", 5000},
		{"tokyo", "plane", 8000},
	}),

	rio_de_janeiro = city.City("rio_de_janeiro", "Rio de Janeiro", city.countries.bra, {
		{"new_york", "boat", 5000},
		{"paris", "plane", 5500},
		{"sydney", "plane", 4000},
		{"cairo", "plane", 5000}
	}),

	tokyo = city.City("tokyo", "Tokyo", city.countries.jpn, {
		{"sydney", "boat", 3000},
		{"sydney", "plane", 5000},
		{"new_york", "plane", 8000},
		{"cairo", "plane", 6000}
	}),

	sydney = city.City("sydney", "Sydney", city.countries.aus, {
		{"tokyo", "boat", 3000},
		{"tokyo", "plane", 5000},
		{"bombay", "plane", 7500},
		{"rio", "plane", 4000}
	}),
}

return city
