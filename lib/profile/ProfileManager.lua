---ProfileManager

local utils = require("lib.utils")
local class = require("lib.classy")
--local profile = require("lib.profile.Profile")
ProfileManager = class("ProfileManager")
local localprofilemanager = require("lib.profile.localprofilemanager")
local ProfileSynchronizer = require("lib.profile.ProfileSynchronizer")

---List the profiles
-- @return profile_list_local representing the list instances of profile
-- @return profile_list_city representing the list of profiles city as string
-- @return profile_list_email representing the list of profiles email_address as string
function ProfileManager:__init()
	self:list()
	self.profilesynchronizer = ProfileSynchronizer()
end

---List the profiles
-- @return profile_list_local representing the list instances of profile
-- @return profile_list_city representing the list of profiles city as string
-- @return profile_list_email representing the list of profiles email_address as string
function ProfileManager:list()
	profile_list_local = localprofilemanager:get_profileslist()
	self.profile_list_local = profile_list_local
	--self.profile_list_city = profile_list_city
	--self.profile_list_email = profile_list_email

	return profile_list_local
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

function ProfileManager:check_login(profile)
	if self.profilesynchronizer:is_connected() then
		if profile:get_id() == 0 then
			local new_profile = self.profilesynchronizer:save_profile(profile)
			if new_profile["error"] then
				return new_profile
			else
				localprofilemanager:save(new_profile)
				return new_profile
			end
		else
			result = self.profilesynchronizer:get_profile(profile:get_login_token())
			if result["error"] then
				return result
			else
				return profile
			end
		end
	else
		return profile
	end


end

---Create profile to local and server
-- @param profile representing the profile to save
-- @return true representing it saves successfully both in local and server
-- @return false representing it saves unsuccessfully in server
function ProfileManager:create_new_profile(profile)

	if self.profilesynchronizer:is_connected() then
		local save_res = self.profilesynchronizer:save_profile(profile)
		if save_res["error"] then
			localprofilemanager:save(profile)
			return true, "Local profile created"
		else
			localprofilemanager:save(save_res)
			return true, "Profile created and saved online"
		end
	else
		localprofilemanager:save(profile)
		return true, "Local profile created"
	end

end

function ProfileManager:check_email(email)
	return self.profilesynchronizer:check_email(email)
end

---Save profile to local and server
-- @param profile representing the profile to save
-- @return true representing it saves successfully both in local and server
-- @return false representing it saves unsuccessfully in server
function ProfileManager:save(profile)

	--check the network
	if self.profilesynchronizer:is_connected() ~= false then
		local profile_new = self.profilesynchronizer:save_profile(profile)
		if profile_new["error"] then
			--print(profile_new["message"])
		else
			localprofilemanager:save(profile_new)
		end
		return true, "Save profile successfully in local and server!"
	else
		localprofilemanager:save(profile)
		return false, "The netowork is not connected!"
	end
end

---Load a profile
-- @param city representing the city of the profile
-- @param email_address representing the email_address of the user
-- @return profile representing the profile instance get from local based the city and email_address
-- @return false representing now profile in local with such city and email_address
function ProfileManager:load(email_address)
	profile = localprofilemanager:load(email_address)

	--check the city and email right or not
	if profile ~= false then
		return profile
	else
		return false, "Wrong about email_address"
	end
end

---Synchronize the profile in server to local
-- @param profile representing profile instance
-- @return server_profile representing the profile instance get from server
function ProfileManager:synchronize(profile)
	server_profile = self.profilesynchronizer:get_profile(localprofilemanager:get_profile_token(profile))

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
	if self.profilesynchronizer:is_connected() == true then
		login_result = self.profilesynchronizer:login(email_address,password)
				--Login server
		if  login_result["error"] then
			return false, "Wrong email address or password!"
		else
			profile = self.profilesynchronizer:get_profile(login_result)
			if profile["error"] then
				return false, "No profile found"
			else
				localprofilemanager:save(profile)
				return true, login_result
			end
		end

	else
		return false, "The netowork is not connected!"
	end
end

return ProfileManager
