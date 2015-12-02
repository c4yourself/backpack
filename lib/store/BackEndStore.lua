-- Needed files
local class = require("lib.classy")
local BackEndStore = class("BackEndStore")
local Item = require("lib.store.Item")
local ProfileManager = require("lib.profile.ProfileManager")
-- Get size of Table
function get_size(input)
	i = 0
	for _ in pairs(input) do i = i+1 end
	return i
end


--- Constructor for ProfileSynchronizer
function BackEndStore:__init()

	-- List of all items

	self.item_list = {Item(1, "Baguette", "Paris", "Good", "data/images/store_items/item1.png",5),
	 									Item(2, "Beret", "Paris", "Fancy", "data/images/store_items/item2.png",45),
										Item(3, "Eiffel Tower", "Paris", "So high", "data/images/store_items/item3.png",90),
										Item(4, "Scooter", "Paris", "Convenient", "data/images/store_items/item4.png",450),
										Item(5, "Sushi", "Tokyo", "Raw", "data/images/store_items/item5.png",35),
										Item(6, "Cherry Blossom", "Tokyo", "Lovely", "data/images/store_items/item6.png",20),
										Item(7, "Game Boy", "Tokyo", "Fun", "data/images/store_items/item7.png",175),
										Item(8, "Samurai Sward", "Tokyo", "Sharp", "data/images/store_items/item8.png",320),
										Item(9, "Curry", "Bombay", "Raw", "data/images/store_items/item9.png",5),
										Item(10, "Buddah", "Bombay", "Peaceful", "data/images/store_items/item10.png",85),
										Item(11, "Rickshaw", "Bombay", "Comfy", "data/images/store_items/item11.png",500),
										Item(12, "Cow", "Bombay", "Holy", "data/images/store_items/item12.png",600),
										Item(13, "Saffron", "Cairo", "Yellow", "data/images/store_items/item13.png",40),
										Item(14, "Carpet", "Cairo", "Maybe flying", "data/images/store_items/item14.png",150),
										Item(15, "Pyramid", "Cairo", "Huge", "data/images/store_items/item15.png",75),
										Item(16, "Genei lamp", "Cairo", "Wishful", "data/images/store_items/item16.png",110),
										Item(17, "Telephone box", "London", "Connected", "data/images/store_items/item17.png",150),
										Item(18, "Tea", "London", "British", "data/images/store_items/item18.png",15),
										Item(19, "Umbrella", "London", "Dry", "data/images/store_items/item19.png",45),
										Item(20, "Big Ben", "London", "Timely", "data/images/store_items/item20.png",65),
										Item(21, "Apple", "New York", "The Big...", "data/images/store_items/item21.png",10),
										Item(22, "Statue of Liberty", "New York", "Free", "data/images/store_items/item22.png",45),
										Item(23, "T-Shirt", "New York", "Touristy", "data/images/store_items/item23.png",80),
										Item(24, "Hamburger", "New York", "Tasty", "data/images/store_items/item24.png",70),
										Item(25, "Jesus Statue", "Rio De Jeneiro", "Saved", "data/images/store_items/item25.png",86),
										Item(26, "Sugarloaf Mountain", "Rio De Jeneiro", "Sweet", "data/images/store_items/item26.png",70),
										Item(27, "Football", "Rio De Jeneiro", "Kicked", "data/images/store_items/item27.png",50),
										Item(28, "Carnival Mask", "Rio De Jeneiro", "Disguised", "data/images/store_items/item28.png",80),
										Item(29, "Kangaroo", "Sydney", "Hoppy", "data/images/store_items/item29.png",165),
										Item(30, "Surfing Board", "Sydney", "Hoppy", "data/images/store_items/item30.png",100),
										Item(31, "Crocodile", "Sydney", "Edgy", "data/images/store_items/item31.png",170),
										Item(32, "Opera House", "Sydney", "Clammy", "data/images/store_items/item32.png",65)
					}




	self.city_list = {["Paris"] = 1, ["Tokyo"] = 2, ["Bombay"] = 3, ["Kairo"] = 4,
										["London"] = 5, ["New York"]= 6, ["Rio De Jeneiro"] = 7, ["Sydney"] = 8}
	-- Matrix for increase value between cities
	self.city_multiplier = {{1, 1.8, 1.4, 1.5, 0.9, 1.2, 1.2, 1.1},
													{1.2, 1, 1.3, 0.8, 1.3, 1.3, 0.9, 1.5},
													{1.2, 1.4, 1, 1.1, 0.9, 1.4, 1.2, 1.5},
													{1.3, 1.3, 0.8, 1, 0.9, 1.4, 1.6, 1.2},
													{0.8, 1.4, 0.9, 1.0, 1, 1.3, 1.3, 1.2},
													{0.9, 1.5, 1.3, 0.9, 1.1, 1, 1.3, 1.1},
													{1.2, 1.6, 1.2, 1.1, 0.9, 1.2, 1, 1.6},
													{0.8, 1.3, 1.1, 1.2, 1.4, 1.6, 1.2, 1}}

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

function BackEndStore:returnOfferPrice(item, curr_city)
	multiplier = self.city_multiplier[self.city_list[item:get_city()]][self.city_list[curr_city]]

	return item:get_price()*multiplier
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
