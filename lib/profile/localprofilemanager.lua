--- localprofilemanager
-- @classmod Profile
local class = require("lib.classy")
local lfs = require("lfs")
local utils = require("lib.utils")
local Profile = require("lib.profile.Profile")
local localprofilemanager = class("localprofilemanager")
local profiles = {}

---Create a profile
---usage
---local profile = require("lib.profile.Profile")
---local profiledisplay = require("lib.profile.profilemanager")
---local Profile
---Profile = profiledisplay.create_profile("John","John@gmail.com","1982-01-02","male")
---print(Profile.name .. " " .. Profile.email_address)

function localprofilemanager:save(profile)
  local path = utils.absolute_path(string.format("data/profile/%s.profile",profile:get_name()))
  local file = io.open(path,"w");
  file:write("{\n")
  file:write("\t\t\"badges\": {},\n")
  file:write("\t\t\"balance\": " .. profile:get_balance() .. ",\n")
  file:write("\t\t\"date_of_birth\": \"" .. profile:get_date_of_birth() .. "\",\n")
  file:write("\t\t\"email_address\": \"" .. profile:get_email_address() .. "\",\n")
  file:write("\t\t\"experience\": " .. profile:get_experience() .. ",\n")
  file:write("\t\t\"id\": " .. profile:get_id() .. ",\n")
  file:write("\t\t\"inventory\": {}\n")
  file:write("\t\t\"login_token\": \"token\",\n")
  file:write("\t\t\"name\": \"" .. profile:get_name() .. "\",\n")
  file:write("\t\t\"password\": \"" .. profile:get_password() .. "\",\n")
  file:write("\t\t\"sex\": \"" .. profile:get_sex() .. "\",\n")
  file:write("}\n")
  return profile
end
function localprofilemanager:load(profile,filename)
  local name, email_address, date_of_birth
  local sex, balance, experience
  local path = utils.absolute_path(string.format("data/profile/%s.profile",filename))
  for line in io.lines(path) do
    if string.match(line,"\"name\"") ~= nil then
      local tmp = {}
      tmp = utils.split(line," ")
      _,_,_,name = string.find(tmp[2],"([\"'])(.-)%1")
    end
    if string.match(line,"\"email_address\"") ~= nil then
      local tmp = {}
      tmp = utils.split(line," ")
      _,_,_,email_address = string.find(tmp[2],"([\"'])(.-)%1")
    end
    if string.match(line,"\"date_of_birth\"") ~= nil then
      local tmp = {}
      tmp = utils.split(line," ")
      _,_,_,date_of_birth = string.find(tmp[2],"([\"'])(.-)%1")
    end
    if string.match(line,"\"sex\"") ~= nil then
      local tmp = {}
      tmp = utils.split(line," ")
      _,_,_,sex = string.find(tmp[2],"([\"'])(.-)%1")
    end
    if string.match(line,"\"balance\"") ~= nil then
      balance = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
    end
    if string.match(line,"\"experience\"") ~= nil then
      experience = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
    end
  end
  profile = Profile(name,email_address,date_of_birth,sex)
  profile:set_balance(balance)
  profile:set_experience(experience)
  return profile
end


---Get the profiles instances
---@param profiles_name representing the name of profiles in the data/profile folder
---usage
---------------------------------------------------------------------------------------
---local profiledisplay = require("lib.profile.profilemanager")
---local profiles = {}
---profiles = profiledisplay.get_profilescontent(profiledisplay.get_profileslist())
---for i =1, #profiles, 1 do
-----modify balance
---if profiles[i].name == "Anna" then
---    profiles[i]:modify_balance(500)
---    profiles[i]:save()
---  end
---end
---------------------------------------------------------------------------------------
function localprofilemanager:get_profileslist()
  print(lfs._VERSION)
  local profiles_name = {}
  local path = utils.absolute_path("data/profile/")
  for file in lfs.dir(path) do
    if string.match(file,".profile") ~= nil then
      --print("Found file:" .. file)
      table.insert(profiles_name, string.sub(file,1,string.find(file,".profile")-1))
    end
  end
  local profiles = {}
  for i = 1, #profiles_name, 1 do
    profiles[i] = localprofilemanager:load(profiles[i],profiles_name[i])
  end
  return profiles
end

return localprofilemanager
