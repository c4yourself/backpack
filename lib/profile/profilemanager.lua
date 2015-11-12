--- List of Profiles
-- @module Profiles_Display

local utils = require("lib.utils")
local lfs = require("lfs")
local Profiles_Manager = {}


--- Get the profiles from profiles folder

function Profiles_Manager.get_profileslist()
  print(lfs._VERSION)
  local profiles = {}
  local path = utils.absolute_path("data/profile/")
  for file in lfs.dir(path) do
    if string.match(file,".profile") ~= nil then
      --print("Found file:" .. file)
      table.insert(profiles, file)
    end
  end
  return profiles
end
return Profiles_Manager
