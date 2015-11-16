local http = require("socket.http")
local ltn12 = require("ltn12")
local class = require("lib.classy")
local hash = require("lib.hash")
local ProfileSynchronizer = class("ProfileSynchronizer")
local json = require("lib.dkjson")
local Profile = require("lib.profile.Profile")

function ProfileSynchronizer:__init()

	self.url = "http://localhost:5000"
	self.login_url = "/profile/authenticate/"
	self.get_profile_url = "/profile/info/"
	self.save_profile_url ="/profile/"
	self.ttlyawesomekey = "c4y0ur5elf"

end

--Test function - not used
function ProfileSynchronizer:test()

		local s = require("lib.serpent")
		local json_request =  [[{"hash":"]].. hash.hash256("c4y0ur5elf")..[["}]]
	  local json_response = { }


	  local request = http.request
	  {
	    url = self.url,
	    method = "POST",
	    headers =
	    {
	      ["Content-Type"] = "application/json",
				['content-length'] = string.len(json_request)
	    },
	    source = ltn12.source.string(json_request),
	    sink = ltn12.sink.table(json_response)
	  }
	  local result = table.concat(json_response)

end

-- Login which receives the token for a given email and password
function ProfileSynchronizer:login(email, password)


	local json_request =  [[{"email":"]]..email..[[","password":"]]..password..[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]
  local json_response = { }


  local request = http.request
  {
    url = self.url..self.login_url,
    method = "POST",
    headers =
    {
      ["Content-Type"] = "application/json",
			['content-length'] = string.len(json_request)
    },
    source = ltn12.source.string(json_request),
    sink = ltn12.sink.table(json_response)
  }
  local result = table.concat(json_response)
	local return_table,pos,err = json.decode(result, 1, nil)

	if err then
		return err
	else
		return return_table.profile_token
	end

end

-- Local function to create an instance of the profile given the data
local function create_existing_profile(data)
	new_profile = Profile(data.name, data.email_address, data.date_of_birth, data.sex, data.current_city)
 	new_profile:set_balance(data.balance)
	new_profile:set_id(data.id)
	new_profile:set_experience(data.experience)
	new_profile:set_login_token(data.profile_token)
	return new_profile
end

-- Returns an instance of the profile given a token
function ProfileSynchronizer:get_profile(token)

	local token_data =  [[{"profile_token":"]]..token..[[","zdata_hash":"49aac7d4ad14540a91c14255ea1288e2fdc9a54e53f01d15371e81345f5e3646"}]]
  local profile_body = { }

  local result, code = http.request
  {
    url = self.url..self.get_profile_url,
    method = "POST",
    headers =
    {
      ["Content-Type"] = "application/json",
			['content-length'] = string.len(token_data)
    },
    source = ltn12.source.string(token_data),
    sink = ltn12.sink.table(profile_body)
  }
  local result = table.concat(profile_body)
	local return_table,pos,err = json.decode(result, 1, nil)
	local return_profile = create_existing_profile(return_table)

	return return_profile
end

-- Deletes the profile given email, password and token
function ProfileSynchronizer:delete_profile()
end

-- Saves the profile (if the ID is 0) or updates a given profile
function ProfileSynchronizer:save_profile(profile)

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

  local profile_body = { }

  local result, code = http.request
  {
    url = self.url..self.save_profile_url,
    method = "POST",
    headers =
    {
      ["Content-Type"] = "application/json",
			['content-length'] = string.len(profile_data)
    },
    source = ltn12.source.string(profile_data),
    sink = ltn12.sink.table(profile_body)
  }
  local result = table.concat(profile_body)
	local return_table,pos,err = json.decode(result, 1, nil)
	local return_profile = create_existing_profile(return_table)

	return return_profile


end

return ProfileSynchronizer
