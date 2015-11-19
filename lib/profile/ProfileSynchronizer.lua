-- Needed files
local http = require("socket.http")
local ltn12 = require("ltn12")
local class = require("lib.classy")
local hash = require("lib.hash")
local ProfileSynchronizer = class("ProfileSynchronizer")
local json = require("lib.dkjson")
local Profile = require("lib.profile.Profile")

-- Some possible test code to use; this really can't be automateed
--[[
local profilesynchronizer = ProfileSynchronizer()
local token = profilesynchronizer:login("Test@gmail.com","password")
if token["error"] then
else
	local profile_test = profilesynchronizer:get_profile(token)
	if profile_test["error"] then
	else
		profile_test:set_balance(2000)
		profile_test:set_id(0)
		profile_test.email_address = "Test3@gmail.com"
		profile_test = profilesynchronizer:save_profile(profile_test)
		if profile_test["error"] then
		end
	end
end
--]]

--- Constructor for ProfileSynchronizer
function ProfileSynchronizer:__init()

	self.url = "http://localhost:5000"
	self.connect_url = "/connect/"
	self.login_url = "/profile/authenticate/"
	self.get_profile_url = "/profile/info/"
	self.save_profile_url ="/profile/"
	self.delete_profile_url = "/profile/delete/"
	self.ttlyawesomekey = "c4y0ur5elf"

end


--- Check if connection to database is working
-- @return boolean true/false depending on if database is up
function ProfileSynchronizer:is_connected()

	local server_url = "http://localhost:5000/connect/"

	-- Do request to server
  local request, code = http.request
  {
    url = server_url,
  }

	if code == 200 then
		return true
	else
		return false
	end

end

--- Local function to create an instance of the profile given the data
-- @param data a table containing all information about a profile
-- @return new_profile A newly created instance of Profileclass
local function create_existing_profile(data)

	-- Constructor
	new_profile = Profile(data.name, data.email_address, data.date_of_birth, data.sex, data.current_city)

	-- And additional data
 	new_profile:set_balance(data.balance)
	new_profile:set_id(data.id)
	new_profile:set_experience(data.experience)
	new_profile:set_login_token(data.profile_token)
	return new_profile
end

--- Combined error handling for all sources
-- @param json_response the response accuired from earlyer server call
-- @param code the error code returned from server
-- @return error if error exists it will be returned
-- @return return_table if no error exists jsondecoded table is returned
local function return_data_check(json_response, code)

	-- Check if HTTP request was OK
	if code == 200 then

		-- Create the returned table of data
		local result = table.concat(json_response)
		local return_table,pos,err = json.decode(result, 1, nil)

		-- If there was an error with creating return data
		if err then
			local error = {}
			error["error"] = true
			error["Code"] = err
			error["message"] = "JSON conversion error, see code"
			return error

		-- If table data was created
		else

			-- Check if there was some problem on the server side
			if return_table["error"] == "true" then
				local error = {}
				error["error"] = true
				error["Code"] = "Server side data error"
				error["message"] = return_table["message"]
				return error

			-- If not, all is well
			else
				return return_table
			end
		end

	-- If there was a HTTP request error
	else
		local error = {}
		error["error"] = true
		error["Code"] = code
		error["message"] = "HTTP error, see code"
		return error
	end
end

--- Local function for all server comnmunication given data and url
-- @param data the json data sent with the server request
-- @param url_extension specific server url depending on server call
-- @return var the JSON-data returned
local function server_communication(data, url_extension)
	-- Base URL for server location
	local url_base = "http://localhost:5000"

	-- return variable
	local json_response = { }

	-- Do request to server
  local request, code = http.request
  {
    url = url_base..url_extension,
    method = "POST",
    headers =
    {
      ["Content-Type"] = "application/json",
			['content-length'] = string.len(data)
    },
    source = ltn12.source.string(data),
    sink = ltn12.sink.table(json_response)
  }

	-- Get result of error handling
	local return_var = return_data_check(json_response, code)
	return return_var
end

--- Login which receives the token for a given email and password
-- @param email a users email
-- @param password a users password
-- @return profile_token a users profiletoken used for other servercalls
function ProfileSynchronizer:login(email, password)

	-- Json request for login
	local json_request =  [[{"email":"]]..email..[[","password":"]]..password..[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]

	result = server_communication(json_request, self.login_url)

	-- Check if we have an error
	if result["error"] then

		-- Return the error table if error
		return result
	else

		-- If no error, return the correct token
		return result.profile_token
	end

end

--- Returns an instance of the profile given a token
-- @param token a users authetication token received by login()
-- @return result a instance of the Profile class
function ProfileSynchronizer:get_profile(token)
	-- Json request for token data
	local token_data =  [[{"profile_token":"]]..token..[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]
	--local token_data =  [[{"profile_token":"]]..token..[[","zdata_hash":"49aac7d4ad14540a91c14255aa1288e2fdc9a54e53f01d15371e81345f5e3646"}]]

	-- Returned result
  result = server_communication(token_data, self.get_profile_url)

	-- Check if we have an error
	if result["error"] then

		-- Return the error table if error
		return result
	else

		-- Otherwise we return the working profile instance
		return create_existing_profile(result)
	end
end

--- Deletes the profile given email, password and token
-- @param email a users email
-- @param password a users password
-- @param token a users authetication token received by login()
-- @return result either error message or message of delete completion
function ProfileSynchronizer:delete_profile(email, password, token)

	local json_request =  [[{"email":"]]..email..[[","password":"]]..password..[[","profile_token":"]]..token..[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]

	result = server_communication(json_request, self.delete_profile_url)

	-- Check if we have an error
	if result["error"] then
		--Return error table if error
		return result
	else
		-- Otherwise we return message "Profile Deleted"
		return result.message
	end
end

--- Saves the profile (if the ID is 0) or updates a given profile
-- @param profile A instance of the Profile class
-- @return result Either error message or the newly created or updated profile
function ProfileSynchronizer:save_profile(profile)

	-- Extract the data from the profile
	local badges = profile:get_badges_string()
	local balance = profile:get_balance()
	local current_city = profile:get_city()
	local date_of_birth = profile:get_date_of_birth()
	local email_address = profile:get_email_address()
	local experience = profile:get_experience()
	local profile_id = profile:get_id()
	local inventory = profile:get_inventory_string()
	local name = profile:get_name()
	local password = profile:get_password()
	local profile_token = profile:get_login_token()
	local sex = profile:get_sex()

	-- Construct the json request from the data
	local profile_data =  [[{"badges":"]]..badges..
												[[","balance":"]]..balance..
												[[","current_city":"]]..current_city..
												[[","date_of_birth":"]]..date_of_birth..
												[[","email_address":"]]..email_address..
												[[","experience":"]]..experience..
												[[","profile_id":"]]..profile_id..
												[[","inventory":"]]..inventory..
												[[","name":"]]..name..
												[[","password":"]]..password..
												[[","profile_token":"]]..profile_token..
												[[","sex":"]]..sex..
												[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]

	-- Make the server request
	result = server_communication(profile_data, self.save_profile_url)

	-- Check if we have an error
	if result["error"] then

		-- If we have one, return the error table
		return result
	else

		-- If not return the profile instantiation
		return create_existing_profile(result)
	end
end

return ProfileSynchronizer
