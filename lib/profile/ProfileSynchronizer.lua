-- Needed files
local http = require("socket.http")
local ltn12 = require("ltn12")
local class = require("lib.classy")
local hash = require("lib.hash")
local ProfileSynchronizer = class("ProfileSynchronizer")
local json = require("lib.dkjson")
local Profile = require("lib.profile.Profile")

-- Constructor
function ProfileSynchronizer:__init()

	self.url = "http://localhost:5000"
	self.login_url = "/profile/authenticate/"
	self.get_profile_url = "/profile/info/"
	self.save_profile_url ="/profile/"
	self.ttlyawesomekey = "c4y0ur5elf"

end

-- Local function to create an instance of the profile given the data
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

-- Local function for all server comnmunication given data and url
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

	-- Check if the request was successful
	if code == 200 then
		-- Concatenate the result
  	local result = table.concat(json_response)
		return result

	-- If not we return an error with the code
	else
		local error = {}
		error["Error"] = true
		error["Code"] = code
		return error
	end
end

-- Login which receives the token for a given email and password
function ProfileSynchronizer:login(email, password)

	-- Json request for login
	local json_request =  [[{"email":"]]..email..[[","password":"]]..password..[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]

	result = server_communication(json_request, self.login_url)

	-- Check if we have an error
	if result["Error"] then
		return result

	-- Or if we don't have an error
	else
		-- Decode the result
		local return_table,pos,err = json.decode(result, 1, nil)

		if err then
			return err
		else
			return return_table.profile_token
		end
	end

end

-- Returns an instance of the profile given a token
function ProfileSynchronizer:get_profile(token)
	-- Json request for token data
	local token_data =  [[{"profile_token":"]]..token..[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]

	-- Returned result
  result = server_communication(token_data, self.get_profile_url)

	-- Check if we have an errror
	if result["Error"] then
		return result

	-- Or if we don't have an error
	else
		-- Decode the result
		local return_table,pos,err = json.decode(result, 1, nil)

		-- Some very basic error handling
		if err then
			return err
		else
			-- Create the profile to return
			local return_profile = create_existing_profile(return_table)

			return return_profile
		end
	end
end

-- Deletes the profile given email, password and token
function ProfileSynchronizer:delete_profile()
end

-- Saves the profile (if the ID is 0) or updates a given profile
function ProfileSynchronizer:save_profile(profile)

	-- Extract the data from the profile
	local badges = "badges"--profile:get_badges()
	local balance = profile:get_balance()
	local current_city = profile:get_city()
	local date_of_birth = profile:get_date_of_birth()
	local email_address = profile:get_email_address()
	local experience = profile:get_experience()
	local profile_id = profile:get_id()
	local inventory = "inventory"--profile:get_inventory()
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
	if result["Error"] then
		return result

	-- Or if we havn't got an error
	else
		-- Decode the data returned
		local return_table,pos,err = json.decode(result, 1, nil)

		-- Some very basic error handling
		if err then
			return err
		else

			-- Create the profile to be returned
			local return_profile = create_existing_profile(return_table)

			return return_profile
		end
	end
end

return ProfileSynchronizer
