local http = require("socket.http")
local ltn12 = require("ltn12")
local class = require("lib.classy")
local hash = require("lib.hash")
local ProfileSynchronizer = class("ProfileSynchronizer")

function ProfileSynchronizer:__init()

	self.url = "http://localhost:5000"
	self.login_url = "/profile/authenticate/"
	self.get_profile_url = "/profile/info/"
	self.ttlyawesomekey = "c4y0ur5elf"

end


function ProfileSynchronizer:test()

		local s = require("lib.serpent")

		local json_request =  [[{"hash":"]].. hash.sha256(self.ttlyawesomekey)..[["}]]
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

function ProfileSynchronizer:login(email, password)


	local json_request =  [[{"email":"]]..email..[[","password":"]]..password..[[","zdata_hash":"pbkdf2:sha1:1000$PWHFjsnl$df9c596f628351d91562422bb47d826d6aa70223"}]]
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




end

function ProfileSynchronizer:connect()
end
function ProfileSynchronizer:get_profile()

	local token_data =  [[{"profile_token":"1337","zdata_hash":"pbkdf2:sha1:1000$PWHFjsnl$df9c596f628351d91562422bb47d826d6aa70223"}]]
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

end
function ProfileSynchronizer:delete_profile()
end
function ProfileSynchronizer:save_profile()
end

return ProfileSynchronizer
