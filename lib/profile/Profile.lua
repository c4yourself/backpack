---Profile
-- @classmod Profile
-- @field name
-- @field email_address
-- @field date_of_birth
-- @field sex
-- @field balance
-- @field experience
-- @field password
-- @field badges
-- @field id
-- @field inventory
-- @field login_token

local city = require("lib.city")
local class = require("lib.classy")
local utils = require("lib.utils")
local Profile = class("Profile")

Profile.name = ""
Profile.email_address = ""
Profile.date_of_birth = ""
Profile.sex = ""
Profile.city = ""
Profile.balance = 0
Profile.experience = 0
Profile.password = ""
Profile.badges = {}
Profile.id = 0
Profile.inventory = {}
Profile.login_token = ""

---Constructor for Profile
-- @param name string representing name of user
-- @param email_address string representing email address of user
-- @param date_of_birth string date birth of user
-- @param sex string representing the gender of the user
-- @param city instance of the current city the profile is located at
function Profile:__init(name,email_address,date_of_birth,sex,city)
	self.name = name
	self.email_address = email_address
	self.date_of_birth = date_of_birth
	self.sex = sex
	self.city = city.code
end

---Get name of the user
-- @return name
function Profile:get_name()
	return self.name
end

---Get profile name
-- @return profile name
function Profile:get_profile_name()
	return string.format("%s__%s",self.city,self.email_address)
end

---Get email_address of the user
-- @return email_address
function Profile:get_email_address()
	return self.email_address
end

---Get date_of_birth of the user
-- @return date_of_birth
function Profile:get_date_of_birth()
	return self.date_of_birth
end

---Get sex of the user
-- @return sex
function Profile:get_sex()
	return self.sex
end

---Get city of the user
-- @return city
function Profile:get_city()
	return city.cities[self.city]
end

---Get  current city of the user
-- @return city
function Profile:get_current_city()
	return self.city
end
---Get balance of the user
-- @return balance
function Profile:get_balance()
	return self.balance
end

---Get balance of the user
-- @return experience
function Profile:get_experience()
	return self.experience
end

---Get password of the user
-- @return password
function Profile:get_password()
	return self.password
end

---Get login_token of the user
-- @return login_token
function Profile:get_login_token()
	return self.login_token
end

---Get id of the user
-- @return id
function Profile:get_id()
	return self.id
end

---Get inventory of the user
-- @return inventory table
function Profile:get_inventory()
	return self.inventory
end

---Get badges of the user
-- @return badges table
function Profile:get_badges()
	return self.badges
end

---Get a string of badges
-- @return badges_string
function Profile:get_badges_string()
	if #self.badges >0 then
		local tmp = string.format("%s",self.badges[1])

		for i = 2, #self.badges, 1 do
			tmp = string.format("%s,%s",tmp,self.badges[i])
		end
		return string.format("[%s]",tmp)
	else
		return "[]"
	end
end

---Get a string of inventory
-- @return inventory_string
function Profile:get_inventory_string()
	if #self.inventory >0 then
		local tmp = string.format("%s",self.inventory[1])

		for i = 2, #self.inventory, 1 do
			tmp = string.format("%s,%s",tmp,self.inventory[i])
		end
		return string.format("{%s}",tmp)
	else
		return "{}"
	end
end

---Set balance of the user
-- @param balance representing balance of the user
-- @return balance
function Profile:set_balance(balance)
	self.balance = balance

	return self.balance
end

---Set name of the user
-- @param name representing name of the user
-- @return name
function Profile:set_name(name)
	self.name = name

	return self.name
end

---Set email_address of the user
-- @param email_address representing email_address of the user
-- @return email_address
function Profile:set_email_address(email_address)
	self.email_address = email_address

	return self.email_address
end

---Set date_of_birth of the user
-- @param date_of_birth representing date_of_birth of the user
-- @return date_of_birth
function Profile:set_date_of_birth(date_of_birth)
	self.date_of_birth = date_of_birth

	return self.date_of_birth
end

---Set sex of the user
-- @param sex representing sex of the user
-- @return sex
function Profile:set_sex(sex)
	self.sex = sex

	return self.sex
end

---Set city of the user
-- @param city representing city of the user
-- @return city
function Profile:set_city(city)
	self.city = city

	return self.city
end

---Set experience of the user
-- @param experience representing experience of the user
-- @return experience
function Profile:set_experience(experience)
	self.experience = experience

	return self.experience
end

---Set password of the user from server
-- @param password representing password of the user from server database
function Profile:set_password(password)
	self.password = password
end

---Set badges from server
-- @param badges_string representing badges of the profile from server database
function Profile:set_badges(badges_string)
	local tmp = {}
	tmp = utils.split(string.sub(badges_string,2, string.len(badges_string) - 1),",")

	for i = 1, #tmp, 1 do
		table.insert(self.badges,tonumber(tmp[i]))
	end
end

---Set inventory from server
-- @param inventory_string representing inventory of the profile from server database
function Profile:set_inventory(inventory_string)
	local tmp = {}
	tmp = utils.split(string.sub(inventory_string,string.find(inventory_string,"{") + 1,string.find(inventory_string,"}") - 1),",")
	self.inventory = {}
	for i = 1, #tmp, 1 do
		--self.inventory[i] = tonumber(tmp[i])
		table.insert(self.inventory, tonumber(tmp[i]))
	end
	--[[
	for i=1, #tmp, 1 do
		table.insert(self.inventory,tonumber(string.sub(tmp[i],string.find(tmp[i]," ") + 1,string.len(tmp[i]))))
	end
	]]
end

---Add item to inventory
-- @param item representing the id of the item
function Profile:add_item(item)
	table.insert(self.inventory, item)
end

---Remove an item from the inventory
-- @param item representing the id of the item
function Profile:remove_item(item)
	local index = 0

	for i,j in pairs(self.inventory) do
		if j == item then
			index = i
		end
	end

	if index > 0 then
		table.remove(self.inventory, index)
	else
		error("No item to remove found")
	end

end

---Set id from server
-- @param id representing id of the profile from server database
function Profile:set_id(id)
	self.id = id
end

--Set login_token from server
-- @param login_token representing login_token of the profile from server database
function Profile:set_login_token(login_token)
	self.login_token = login_token
end

--Modify balance of the user
-- @param number representing the change of balance
-- @return balance
function Profile:modify_balance(number)
	self.balance = self.balance + number
	--[[
	Event:__init()
	call_back = function(...)
		ProfileManager:save(...)
	end
	Event:on("balance_change",call_back)
	Event:trigger("balance_change",self)
	]]
	return self.balance
end

---Modify experience of the user
-- @param number representing the change of experience
-- @return experience
function Profile:modify_experience(number)
	if number >= 0 then
		self.experience = self.experience + number
	end

	--Event:__init()
	--call_back = function(...)
	--	ProfileManager:save(...)
	--end
	--Event:on("experience_change",call_back)
	--Event:trigger("experience_change",self)
	return self.experience
end

function Profile:get_level()
	return
		(self.experience - (self.experience % 100)) / 100 + 1,
		self.experience % 100,
		100
end

return Profile
