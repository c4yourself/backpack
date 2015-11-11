--- Profile
-- @classmod Profile

local class = require("lib.classy")
local utils = require("lib.utils")
local Profile = class("Profile")
local event = require("lib.event")

Profile.name = ""
Profile.email_address = ""
Profile.date_of_birth = ""
Profile.sex = ""
Profile.balance = 0
Profile.experience = 0
Profile.password = ""

--- Constructor for Profile
-- @param name string representing name of user
-- @param email_address string representing email address of user
-- @param date_of_birth string date birth of user
-- @param sex string representing the gender of the user
function Profile:__init(name,email_address,date_of_birth,sex)
	self.name = name
	self.email_address = email_address
	self.date_of_birth = date_of_birth
	self.sex = sex
end

-- Set balance of the user
-- @param balance representing balance of the user
function Profile:set_balance(balance)
	self.balance = balance
	return self.balance
end

-- Set experience of the user
-- @param experience representing experience of the user
function Profile:set_experience(experience)
	self.experience = experience
	return self.experience
end

-- Set password of the user
-- @param password representing password of the user
function Profile:set_password(password)
	self.password = password
	return self.password
end

-- Modify balance of the user
-- @param number representing the change of balance
function Profile:modify_balance(number)
	self.balance = self.balance + number
	return self.balance
end

-- Modify experience of the user
-- @param number representing the change of experience
function Profile:modify_experience(number)
	if number >= 0 then
		self.experience = self.experience + number
	end
	return self.experience
end

-- Save profile
function Profile:save()
	local path = utils.absolute_path(string.format("data/profile/%s.profile",self.name))
	local file = io.open(path,"w");
	file:write("{\n")
	file:write("\t\t\"badges\": ,\n")
	file:write("\t\t\"balance\": " .. self.balance .. ",\n")
	file:write("\t\t\"date_of_birth\": \"" .. self.date_of_birth .. "\",\n")
	file:write("\t\t\"email_address\": " .. self.email_address .. "\",\n")
	file:write("\t\t\"experience\": " .. self.experience .. ",\n")
	file:write("\t\t\"id\": ,\n")
	file:write("\t\t\"inventory\": {}\n")
	file:write("\t\t\"login_token\": \"token\",\n")
	file:write("\t\t\"name\": \"" .. self.name .. "\",\n")
	file:write("\t\t\"password\": \"" .. self.password .. "\",\n")
	file:write("\t\t\"sex\": \"" .. self.sex .. "\",\n")
	file:write("}\n")
end
-- load profile
function Profile:load()
	local path = utils.absolute_path(string.format("data/profile/%s.profile",self.name))
	for line in io.lines(path) do
		if string.match(line,"\"balance\"") ~= nil then
			self.balance = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
		end
		if string.match(line,"\"experience\"") ~= nil then
			self.experience = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
		end
		if string.match(line,"\"name\"") ~= nil then
			local tmp = {}
			tmp = utils.split(line," ")
			_,_,_,self.name = string.find(tmp[2],"([\"'])(.-)%1")
		end
	end
	return self.name, self.balance, self.experience
end

return Profile
