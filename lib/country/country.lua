--- Country logics
-- @module Country
local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")

local Country = class("Country")

--- Constructor for Country
-- @param name Name of country that is displayed to the user
-- @param country_code Three letter country code. Find them at Countrycode.org
-- @param currency_format(optional) printf compatible string. For USD, $%.2f and for SEK %.2f kr.
-- @param cities(optional) a table of cities in this country
-- @param exchange_rate(optional) is a rate between this country and base currency. Defailt is 1

function Country:__init(name, country_code, currency_format, cities, exchange_rate)

	self.name = name
  self.country_code = country_code
  self.currency_format = currency_format or "%.2f"
  self.cities = cities

  if(exchange_rate ~= nil) then
    self.exchange_rate = exchange_rate
  else
    self.exchange_rate = 1
  end

end

function Country:format_balance(balance)
  return string.format(
    self.currency_format, self:universal_to_local_currency(balance))
end

function Country:universal_to_local_currency(balance)
  return balance*self.exchange_rate
end

function Country:local_currency_to_universal(local_balance)
  return local_balance*self.exchange_rate
end

return Country
