---localprofilemanager
-- @classmod localprofilemanager

local class = require("lib.classy")
--local lfs = require("lfs")
local utils = require("lib.utils")
local Profile = require("lib.profile.Profile")
local localprofilemanager = class("localprofilemanager")
local city = require("lib.city")

---Create a profile
-- @param profile representing a profile instance
-- @return profile representing the instance of profile
function localprofilemanager:save(profile)
	local path = utils.absolute_path(
	string.format("data/profile/%s.json",profile:get_email_address()))
	local file = io.open(path,"w");

	--generate a file and write date into it
	file:write("{\n")
	file:write("\t\t\"badges\": " .. profile:get_badges_string() .. ",\n")
	file:write("\t\t\"balance\": " .. profile:get_experience() .. ",\n")
	file:write("\t\t\"date_of_birth\": \"" .. profile:get_date_of_birth() .. "\",\n")
	file:write("\t\t\"email_address\": \"" .. profile:get_email_address() .. "\",\n")
	file:write("\t\t\"experience\": " .. profile:get_experience() .. ",\n")
	file:write("\t\t\"id\": " .. profile:get_id() .. ",\n")
	file:write("\t\t\"inventory\": \"" .. profile:get_inventory_string() .. "\",\n")
	file:write("\t\t\"login_token\": \"" .. profile:get_login_token() .. "\",\n")
	file:write("\t\t\"name\": \"" .. profile:get_name() .. "\",\n")
	file:write("\t\t\"password\": \"" .. profile:get_password() .. "\",\n")
	file:write("\t\t\"sex\": \"" .. profile:get_sex() .. "\",\n")
	file:write("\t\t\"city\": \"" .. profile:get_city().code .. "\",\n")
	file:write("}\n")
	file:close()

	local profile_list = {}
	local path = utils.absolute_path("data/profile/profile.config")
	local profile_name = profile:get_email_address()

	if self:check_config(profile_name) ~= true then
		for line in io.lines(path) do
			table.insert(profile_list,line)
		end
		table.insert(profile_list,1,profile:get_email_address())

		local file = io.open(path,"w+");
		for i = 1, #profile_list, 1 do
			file:write(profile_list[i] .. "\n")
		end
		file:close()
	end

	return profile
end

---Load a local profile
-- @param profile_email
-- @return profile representing the instance of profile
-- @return false representing the file path is illegal
function localprofilemanager:load(profile_email)
	local profile_tmp = {}
	local name, email_address, date_of_birth
	local sex, tmp_city, balance, experience, inventory
	local path = utils.absolute_path(string.format("data/profile/%s.json",profile_email))

	--check the file exist or not
	if self:check_config(profile_email) == true then

		--open the file by io
		for line in io.lines(path) do

			--match name
			if string.match(line,"\"name\"") ~= nil then
				local tmp = {}
				tmp = utils.split(line," ")
				_,_,_,name = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match email_address
			if string.match(line,"\"email_address\"") ~= nil then
				local tmp = {}
				tmp = utils.split(line," ")
				_,_,_,email_address = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match date_of_birth
			if string.match(line,"\"date_of_birth\"") ~= nil then
				local tmp = {}
				tmp = utils.split(line," ")
				_,_,_,date_of_birth = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match sex
			if string.match(line,"\"sex\"") ~= nil then
				local tmp = {}
				tmp = utils.split(line," ")
				_,_,_,sex = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match city
			if string.match(line,"\"city\"") ~= nil then
				local tmp = {}
				tmp = utils.split(line," ")
				_,_,_,tmp_city = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match token
			if string.match(line,"\"login_token\"") ~= nil then
				local tmp = {}
				tmp = utils.split(line," ")
				_,_,_,token = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match inventory
			if string.match(line,"\"inventory\"") ~= nil then
				local tmp = {}
				tmp = utils.split(line," ")
				_,_,_,inventory = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match balance
			if string.match(line,"\"balance\"") ~= nil then
				balance = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
			end

			--match experience
			if string.match(line,"\"experience\"") ~= nil then
				experience = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
			end

			--match id
			if string.match(line,"\"id\"") ~= nil then
				id = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
			end
		end

		--generate a profile instance
		profile_tmp = Profile(name,email_address,date_of_birth,sex,city.cities[tmp_city])
		profile_tmp:set_balance(balance)
		profile_tmp:set_experience(experience)
		profile_tmp:set_inventory(inventory)
		profile_tmp:set_login_token(token)
		profile_tmp:set_id(id)
		io.close()

		return profile_tmp
	else
		return false
	end
end

---Get the profiles instances
-- @return profiles representing the list of profile instance
-- @return false representing the dir is illegal
function localprofilemanager:get_profileslist()
	local profilename_list = {}
	local profile_list = {}
	local path = utils.absolute_path("data/profile/profile.config")
	for line in io.lines(path) do
		table.insert(profilename_list,line)
	end
	io.close()
	for i = 1, #profilename_list, 1 do
		profile_list[i] = self:load(profilename_list[i])
	end
	return profile_list
end

---Remove a profile
-- @param profile representing the name of the profile to remove
-- @return true representing remove successfully
-- @return false representing remove unsuccessfully
function localprofilemanager:delete(profile)
	local profile_list = {}
	local path = utils.absolute_path("data/profile/profile.config")
	local profile_name = profile:get_email_address()
	for line in io.lines(path) do
		if string.find(line,profile_name) ~= nil then
			--table.insert(profile_list,string.format("%s false",profile_name))
		else
			table.insert(profile_list,line)
		end
	end
	io.close()
	local file = io.open(path,"w+");
	for i = 1, #profile_list, 1 do
		file:write(profile_list[i] .. "\n")
	end
	file:close()
	--traverse the dir of the data/profile to match the profile filename
	--for file in lfs.dir(path) do
	--	if string.match(file,string.format("%s",profile:get_email_address())) ~= nil then
	--		local thefile = utils.absolute_path(string.format("data/profile/%s.json",profile:get_email_address()))

			--check the file in the folder
	--		if(lfs.attributes(thefile, "mode") ~= "directory") then
	--			resultOK, errorMsg = os.remove(thefile)
	--			if resultOK then
	--				return true
	--			else
	--				return false
	--			end
	--		end
	--	end
	--end
end
function localprofilemanager:get_list()
	local profile_list = {}
	local path = utils.absolute_path("data/profile/profile.config")
	for line in io.lines(path) do
		table.insert(profile_list,line)
	end
	io.close()
	return profile_list
end
---Get token in profile
-- @param profile representing the profile instance
-- @return token representing the token of the profile
function localprofilemanager:get_profile_token(profile)
	return profile:get_login_token()
end

---Get email_address, password and login_token in profile
-- @param profile representing the profile instance
function localprofilemanager:get_delete_params(profile)
	return profile:get_email_address(), profile:get_password(), profile:get_login_token()
end
function localprofilemanager:check_config(profile_email)
	local path = utils.absolute_path("data/profile/profile.config")
	local result = false
	for line in io.lines(path) do
		if string.find(line,profile_email) ~= nil then
			if #line == #profile_email then
				result = true
			end
		end
	end
	io.close()
	return result
end
return localprofilemanager
