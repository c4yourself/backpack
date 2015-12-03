--- City logics
-- @module city
local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")

local City = class("City")

--- Constructor for city
-- @param code is a lowercase name for this city. The value is used to uniquely identify the city. Rio de janeiro would be rio_de_janeiro.
-- @param name is the name of the city
-- @param country, country instance for this city
-- @param travel_routes contains a list of available destinations. Format for this list is {city, mean of travel, cost}, example {"paris", "train", 300}

function City:__init(code, name, country, travel_routes)
	self.code = code
	self.name = name
	self.country = country
	self.travel_routes = travel_routes
end

return City
