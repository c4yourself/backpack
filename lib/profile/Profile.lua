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
Profile.badges = {}
Profile.id = 0
Profile.inventory = {}

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

-- Get name of the user
function Profile:get_name()
	return self.name
end
-- Get email_address of the user
function Profile:get_email_address()
	return self.email_address
end

-- Get email_address of the user
function Profile:get_date_of_birth()
	return self.date_of_birth
end

-- Get sex of the user
function Profile:get_sex()
	return self.sex
end
-- Get balance of the user
function Profile:get_balance()
	return self.balance
end
-- Get balance of the user
function Profile:get_password()
	return self.password
end
-- Set experience of the user
-- @param experience representing experience of the user
function Profile:set_experience(experience)
	self.experience = experience
	return self.experience
end
-- Get balance of the user
function Profile:get_experience()
	return self.experience
end
-- Set password of the user from server
-- @param password representing password of the user from server database
function Profile:set_password(password)
	self.password = password
	--return self.password
end
-- get badges from server
-- @param badges representing badges of the profile from server database
function Profile:set_badges(badges)
	self.badges = badges
	--return self.badges
end
function Profile:set_id(id)
	self.id = id
end
-- get profile id from server
-- @param id representing id of the profile from server database
function Profile:get_id()
	return self.id
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
return Profile
