-- Needed files
local class = require("lib.classy")
local BackEndStore = class("BackEndStore")
local Item = require("lib.store.Item")

-- Get size of Table
function get_size(input)
	i = 0
	for _ in pairs(input) do i = i+1 end
	return i
end


--- Constructor for ProfileSynchronizer
function BackEndStore:__init()
--[[
	self.a = Item(1, "Baguette", "Paris", "Good", "data/images/item_1.png",5)
	self.b = Item(2, "Barret", "Paris", "Fancy", "data/images/item_2.png",45)
	self.c = Item(3, "Sushi", "Tokyo", "Raw", "data/images/item_3.png",15)
	self.d = Item(4, "Knife", "Tokyo", "Sharp", "data/images/item_4.png",78)

	self.item_list = {self.a,self.b,self.c,self.d}]]
	-- List of all items

	self.item_list = {Item(1, "Baguette", "Paris", "Good", "data/images/item_1.png",5),
	 									Item(2, "Barret", "Paris", "Fancy", "data/images/item_2.png",45),
										Item(3, "Eifel Tower", "Paris", "So high", "data/images/item_3.png",45),
										Item(4, "Barret", "Paris", "Fancy", "data/images/item_4.png",45),
										Item(5, "Sushi", "Tokyo", "Raw", "data/images/item_9.png",15),
										Item(6, "Knife", "Tokyo", "Sharp", "data/images/item_10png",78),
										Item(7, "Sushi", "Tokyo", "Raw", "data/images/item_9.png",15),
										Item(8, "Sushi", "Tokyo", "Raw", "data/images/item_9.png",15),}



	self.city_list = {["Paris"] = 1, ["Tokyo"] = 2}
	-- Matrix for increase value between cities
	self.city_multiplier = {{1, 1.5 }, {1.2, 1}}

end

function BackEndStore:returnItemList(city)
	local ret_list = {}
	local count = 1
	local i = 1
	while i <= get_size(self.item_list) do
		if self.item_list[i]:get_city() == city then
			ret_list[count] = self.item_list[i]
			count = count + 1
		end
		i = i + 1
	end
	return ret_list
end

function BackEndStore:reutrnOfferPrice(item, curr_city)
	local multiplier = self.city_multiplier[self.city_list[item.get_city()]][self.city_list[curr_city]]
	return item.get_price()*multiplier
end

function BackEndStore:returnItem(id)
	local i = 1
	while i <= get_size(self.item_list) do
		if self.item_list[i]:get_id() == id then
			return self.item_list[i]
		end
		i = i+1
	end
	return error("Trying to find non-existing item")
end

function BackEndStore:returnBackPackItems(inventory)
	local i = 1
	local j = 1
	local ret_list = {}

	while i <= #inventory do
		while j <= get_size(self.item_list) do
			if self.item_list[j]:get_id() == inventory[i] then
				ret_list[i] = self.item_list[j]
			end
			j = j+1
		end
		j = 1
		i = i+1
	end
	return ret_list
end

return BackEndStore
