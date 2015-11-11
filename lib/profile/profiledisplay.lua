--- List of Profiles
-- @module Profiles_Display


local Profiles_Display = {}
local lfs = require("lfs")
local utils = require("lib.utils")

--- Get the profiles from profiles folder

function Profiles_Display.get_profileslist()
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


return Profiles_Display
