-- Needed files
local class = require("lib.classy")
local utils = require("lib.utils")
local Item = class("Item")


--- Constructor for ProfileSynchronizer
function Item:__init(id, name, city, description, image_path, price)
	self.id = id
	self.name = name
	self.city = city
	self.description = description
	self.image_path = image_path
	self.price = price

end

--- Getters for all different parameters

function Item:get_id()
	return self.id
end

function Item:get_name()
	return self.name
end

function Item:get_city()
	return self.city
end

function Item:get_description()
	return self.description
end

function Item:get_image_path()
	return self.image_path
end

function Item:get_price()
	return self.price
end

return Item
