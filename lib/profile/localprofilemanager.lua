--- localprofilemanager
-- @classmod localprofilemanager

local class = require("lib.classy")
local lfs = require("lfs")
local utils = require("lib.utils")
local Profile = require("lib.profile.Profile")
local localprofilemanager = class("localprofilemanager")

-- Create a profile
-- @param profile representing a profile instance
-- @return profile representing the instance of profile
function localprofilemanager:save(profile)
	local path = utils.absolute_path(
	string.format("data/profile/%s__%s.profile",profile:get_city(),profile:get_email_address()))
	local file = io.open(path,"w");

	--generate a file and write date into it
	file:write("{\n")
	file:write("\t\t\"badges\": " .. profile:get_badges_string() .. ",\n")
	file:write("\t\t\"balance\": " .. profile:get_balance() .. ",\n")
	file:write("\t\t\"date_of_birth\": \"" .. profile:get_date_of_birth() .. "\",\n")
	file:write("\t\t\"email_address\": \"" .. profile:get_email_address() .. "\",\n")
	file:write("\t\t\"experience\": " .. profile:get_experience() .. ",\n")
	file:write("\t\t\"id\": " .. profile:get_id() .. ",\n")
	file:write("\t\t\"inventory\": " .. profile:get_inventory_string() .. ",\n")
	file:write("\t\t\"login_token\": \" \",\n")
	file:write("\t\t\"name\": \"" .. profile:get_profile_name() .. "\",\n")
	file:write("\t\t\"password\": \"" .. profile:get_password() .. "\",\n")
	file:write("\t\t\"sex\": \"" .. profile:get_sex() .. "\",\n")
	file:write("\t\t\"city\": \"" .. profile:get_city() .. "\",\n")
	file:write("}\n")
	file:close()

	return profile
end

-- Load a local profile
-- @param profile representing a nil table to generate a profile instance
-- @param filename representing the unique identifier of a profile
-- @return profile representing the instance of profile
-- @return false representing the file path is illegal
function localprofilemanager:load(profile_city, profile_email)
	local profile
	local name, email_address, date_of_birth
	local sex, city, balance, experience
	local path = utils.absolute_path(string.format("data/profile/%s__%s.profile",profile_city,profile_email))

	--check the file exist or not
	if(lfs.attributes(path, "mode") == "file") then

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
				_,_,_,city = string.find(tmp[2],"([\"'])(.-)%1")
			end

			--match balance
			if string.match(line,"\"balance\"") ~= nil then
				balance = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
			end

			--match experience
			if string.match(line,"\"experience\"") ~= nil then
				experience = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
			end
		end

		--generate a profile instance
		profile = Profile(name,email_address,date_of_birth,sex,city)
		profile:set_balance(balance)
		profile:set_experience(experience)
		io.close()

		return profile
	else
		return false
	end
end

-- Get the profiles instances
-- @return profiles representing the list of profile instance
-- @return false representing the dir is illegal
function localprofilemanager:get_profileslist()
	local profiles_name = {}
	local path = utils.absolute_path("data/profile/")

	--check the dir exists or not
	if(lfs.attributes(path, "mode") == "directory") then
		for file in lfs.dir(path) do

			--match the .profile file and get all the files' filename in the directory
			if string.match(file,".profile") ~= nil then
				table.insert(profiles_name, string.sub(file,1,string.find(file,".profile")-1))
			end
		end

		local profiles = {}
		local profiles_city_list = {}
		local profiles_email_address_list = {}

		--seperate the filename to get the city list and email_address list and the filename list
		for i = 1, #profiles_name, 1 do
			profiles[i] = localprofilemanager:load(
			string.sub(profiles_name[i],1,string.find(profiles_name[i],"__") - 1),
			string.sub(profiles_name[i],string.find(profiles_name[i],"__") + 2,string.len(profiles_name[i])))
			profiles_city_list[i] = string.sub(profiles_name[i],1,string.find(profiles_name[i],"__") - 1)
			profiles_email_address_list[i] = string.sub(profiles_name[i],string.find(profiles_name[i],"__") + 2,string.len(profiles_name[i]))
		end

		return profiles, profiles_city_list, profiles_email_address_list
	else
		return false
	end
end

-- Remove a profile
-- @param filename representing the name of the profile to remove
-- @return true representing remove successfully
-- @return false representing remove unsuccessfully
-- @usage
-- --if localprofilemanager:remove("Anna") then
-- --  -- remove success
-- --else
-- --  -- remove fail
-- --end
function localprofilemanager:delete(profile)
	local path = utils.absolute_path("data/profile/")

	--traverse the dir of the data/profile to match the profile filename
	for file in lfs.dir(path) do
		if string.match(file,string.format("%s__%s",profile:get_city(),profile:get_email_address())) ~= nil then
			local thefile = utils.absolute_path(string.format("data/profile/%s__%s.profile", profile:get_city(),profile:get_email_address()))

			--check the file in the folder
			if(lfs.attributes(thefile, "mode") ~= "directory") then
				resultOK, errorMsg = os.remove(thefile)
				if resultOK then
					return true
				else
					return false
				end
			end
		end
	end
end

-- Get token in profile
-- @param profile representing the profile instance
-- @return token representing the token of the profile
function localprofilemanager:get_profile_token(profile)
	return profile:get_login_token()
end

-- Get email_address, password and login_token in profile
-- @param profile representing the profile instance
function localprofilemanager:get_delete_params(profile)
	return profile:get_email_address(), profile:get_password(), profile:get_login_token()
end

return localprofilemanager