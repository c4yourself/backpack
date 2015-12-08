---localprofilemanager
-- @classmod localprofilemanager

local class = require("lib.classy")
--local lfs = require("lfs")
local json = require("lib.dkjson")
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
	file:write("\t\t\"balance\": " .. profile:get_balance() .. ",\n")
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
		local file = io.open(path,"rb")
		local file_content = file:read("*all")
		file:close()
		local profile_table = json.decode(file_content, 1, nil)

		profile_tmp = Profile(profile_table.name, profile_table.email_address, profile_table.date_of_birth,
													profile_table.sex, city.cities[profile_table.city])
		profile_tmp:set_balance(tonumber(profile_table.balance))
		profile_tmp:set_experience(tonumber(profile_table.experience))
		profile_tmp:set_inventory(profile_table.inventory)
		profile_tmp:set_login_token(profile_table.login_token)
		profile_tmp:set_id(profile_table.id)
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
