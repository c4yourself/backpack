---ProfileManager

local utils = require("lib.utils")
local lfs = require("lfs")
local class = require("lib.classy")
--local profile = require("lib.profile.Profile")
ProfileManager = class("ProfileManager")
local localprofilemanager = require("lib.profile.localprofilemanager")
local profilesynchronizer = require("lib.profile.ProfileSynchronizer")

---List the profiles
-- @return profile_list_local representing the list instances of profile
-- @return profile_list_city representing the list of profiles city as string
-- @return profile_list_email representing the list of profiles email_address as string
function ProfileManager:__init()
	self:list()
end

---List the profiles
-- @return profile_list_local representing the list instances of profile
-- @return profile_list_city representing the list of profiles city as string
-- @return profile_list_email representing the list of profiles email_address as string
function ProfileManager:list()
	profile_list_local, profile_list_email = localprofilemanager.get_profileslist()
	self.profile_list_local = profile_list_local
	--self.profile_list_city = profile_list_city
	self.profile_list_email = profile_list_email
	return profile_list_local, profile_list_email
end


function ProfileManager:get_local()
	return self.profile_list_local
end

--function ProfileManager:get_cities()
--	return self.profile_list_city
--end

function ProfileManager:get_email()
	return self.profile_list_email
end

---Create profile to local and server
-- @param profile representing the profile to save
-- @return true representing it saves successfully both in local and server
-- @return false representing it saves unsuccessfully in server
function ProfileManager:create_new_profile(profile)
	localprofilemanager:save(profile)

	--check the network
	if profilesynchronizer:is_connected() ~= false then
		profilesynchronizer:delete_profile(localprofilemanager:get_delete_params(profile))
		profilesynchronizer:save_profile(profile)

		return true, "Create new profile successfully in local and server!"
	else
		return false, "Create new local profile successfully. The netowork is not connected!"
	end
end

---Save profile to local and server
-- @param profile representing the profile to save
-- @return true representing it saves successfully both in local and server
-- @return false representing it saves unsuccessfully in server
function ProfileManager:save(profile)
	localprofilemanager:save(profile)

	--check the network
	if profilesynchronizer:is_connected() ~= false then
		profilesynchronizer:save_profile(profile)

		return true, "Save profile successfully in local and server!"
	else
		return false, "The netowork is not connected!"
	end
end

---Load a profile
-- @param city representing the city of the profile
-- @param email_address representing the email_address of the user
-- @return profile representing the profile instance get from local based the city and email_address
-- @return false representing now profile in local with such city and email_address
function ProfileManager:load(city,email_address)
	profile = localprofilemanager:load(city,email_address)

	--check the city and email right or not
	if profile ~= false then
		return profile
	else
		return false, "Wrong about city and email_address"
	end
end

---Synchronize the profile in server to local
-- @param profile representing profile instance
-- @return server_profile representing the profile instance get from server
function ProfileManager:synchronize(profile)
	server_profile = profilesynchronizer:get_profile(localprofilemanager:get_profile_token(profile))

	--check if it's a profile instance form server
	if server_profile ~= nil then
		localprofilemanager:save(server_profile)
		return server_profile
	else
		return false
	end
end

---Delete profile
-- @param profile representing the profile to delete
function ProfileManager:delete(profile)
	localprofilemanager:delete(profile)
end

---Login
-- @param email_address
-- @param password
-- @return true email_address and password
-- @return false email_address or password is wrong or network is not connected
function ProfileManager:login(email_address,password)
	--check the network
	if profilesynchronizer:is_connected() == true then

		--Login server
		if profilesynchronizer:login(email_address,password) == "login_token" then
			return true, email_address, password
		else
			return false, "Wrong email address or password!"
		end

	else
		return false, "The netowork is not connected!"
	end
end

return ProfileManager
