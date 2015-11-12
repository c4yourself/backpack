--- List of Profiles
-- @module Profiles_Display

local utils = require("lib.utils")
local lfs = require("lfs")
local profile = require("lib.profile.Profile")
local Profiles_Manager = {}

---Create a profile
---usage
---   local profile = require("lib.profile.Profile")
---   local profiledisplay = require("lib.profile.profilemanager")
---   local Profile
---   Profile = profiledisplay.create_profile("John","John@gmail.com","1982-01-02","male")
---   print(Profile.name .. " " .. Profile.email_address)
function Profiles_Manager.create_profile(name,email_address,date_of_birth,sex)
  Profile=profile(name,email_address,date_of_birth,sex)
  Profile:save()
  return Profile
end

---Get the profiles name from profiles folder
function Profiles_Manager.get_profileslist()
  print(lfs._VERSION)
  local profiles = {}
  local path = utils.absolute_path("data/profile/")
  for file in lfs.dir(path) do
    if string.match(file,".profile") ~= nil then
      --print("Found file:" .. file)
      table.insert(profiles, string.sub(file,1,string.find(file,".profile")-1))
    end
  end
  return profiles
end
---Get the profiles instances
---@param profiles_name representing the name of profiles in the data/profile folder
---usage
---------------------------------------------------------------------------------------
---   local profiledisplay = require("lib.profile.profilemanager")
---   local profiles = {}
---   profiles = profiledisplay.get_profilescontent(profiledisplay.get_profileslist())
---   for i =1, #profiles, 1 do
---      --modify balance
---     if profiles[i].name == "Anna" then
---       profiles[i]:modify_balance(500)
---       profiles[i]:save()
---     end
---   end
---------------------------------------------------------------------------------------
function Profiles_Manager.get_profilescontent(profiles_name)
  local profiles = {}
  local name, email_address, date_of_birth, sex
  local balance, experience
  for i = 1, #profiles_name, 1 do
    name, email_address, date_of_birth, sex, balance, experience = profile:load(profiles_name[i])
    profiles[i] = profile(name, email_address, date_of_birth, sex)
    profiles[i]:set_balance(balance)
    profiles[i]:set_experience(experience)
  end
  return profiles
end
return Profiles_Manager
