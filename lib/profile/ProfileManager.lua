---List of Profiles
---@module Profiles_Display
local utils = require("lib.utils")
local lfs = require("lfs")
local class = require("lib.classy")
--local profile = require("lib.profile.Profile")
local ProfileManager = class("ProfileManager")
--local localprofilemangager = require("lib.profile.localprofilemangager")

function ProfileManager:__init()
end

function ProfileManager:list()
  --profile_list_local = localprofilemangager.list()
  --profile_list_server = serverprofilemangager.list()
  profile_list_local = "hej"
  return profile_list_local
end

function ProfileManager:save(profile)
  --serverprofilemangager.save(profile)
  --localprofilemangager.save(profile)
end


function ProfileManager:delete()


end

function ProfileManager:login()


end

return ProfileManager
