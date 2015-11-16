--- localprofilemanager
-- @classmod localprofilemanager

local class = require("lib.classy")
local lfs = require("lfs")
local utils = require("lib.utils")
local Profile = require("lib.profile.Profile")
local localprofilemanager = class("localprofilemanager")

-- Create a profile
-- @param profile representing a profile instance
-- @return profile representing the instance of profile
function localprofilemanager:save(profile)
  local path = utils.absolute_path(
  string.format("data/profile/%s__%s.profile",profile:get_city(),profile:get_email_address())
  )
  local file = io.open(path,"w");

  file:write("{\n")
  file:write("\t\t\"badges\": {},\n")
  file:write("\t\t\"balance\": " .. profile:get_balance() .. ",\n")
  file:write("\t\t\"date_of_birth\": \"" .. profile:get_date_of_birth() .. "\",\n")
  file:write("\t\t\"email_address\": \"" .. profile:get_email_address() .. "\",\n")
  file:write("\t\t\"experience\": " .. profile:get_experience() .. ",\n")
  file:write("\t\t\"id\": " .. profile:get_id() .. ",\n")
  file:write("\t\t\"inventory\": {}\n")
  file:write("\t\t\"login_token\":" .. profile:get_login_token() .. ",\n")
  file:write("\t\t\"name\": \"" .. profile:get_profile_name() .. "\",\n")
  file:write("\t\t\"password\": \"" .. profile:get_password() .. "\",\n")
  file:write("\t\t\"sex\": \"" .. profile:get_sex() .. "\",\n")
  file:write("\t\t\"city\": \"" .. profile:get_city() .. "\",\n")
  file:write("}\n")
  file:close()

  return profile
end

-- Load a local profile
-- @param profile representing a nil table to generate a profile instance
-- @param filename representing the unique identifier of a profile
-- @return profile representing the instance of profile
-- @return false representing the file path is illegal
function localprofilemanager:load(profile_city, profile_email)
  local profile
  local name, email_address, date_of_birth
  local sex, city, balance, experience
  local path = utils.absolute_path(string.format("data/profile/%s__%s.profile",profile_city,profile_email))

  if(lfs.attributes(path, "mode") == "file") then
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

      if string.match(line,"\"city\"") ~= nil then
        local tmp = {}
        tmp = utils.split(line," ")
        _,_,_,city = string.find(tmp[2],"([\"'])(.-)%1")
      end

      if string.match(line,"\"balance\"") ~= nil then
        balance = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
      end

      if string.match(line,"\"experience\"") ~= nil then
        experience = tonumber(string.sub(line,string.find(line," ")+1,string.find(line,",")-1))
      end
    end

    profile = Profile(name,email_address,date_of_birth,sex,city)
    profile:set_balance(balance)
    profile:set_experience(experience)
    io.close()
    return profile
  else
    return false
  end
end

-- Get the profiles instances
-- @return profiles representing the list of profile instance
-- @return false representing the dir is illegal
function localprofilemanager:get_profileslist()
  local profiles_name = {}
  local path = utils.absolute_path("data/profile/")

  if(lfs.attributes(path, "mode") == "directory") then
    for file in lfs.dir(path) do
      if string.match(file,".profile") ~= nil then
        table.insert(profiles_name, string.sub(file,1,string.find(file,".profile")-1))
      end
    end

    local profiles = {}

    for i = 1, #profiles_name, 1 do
      profiles[i] = localprofilemanager:load(
      string.sub(profiles_name[i],1,string.find(profiles_name[i],"__") - 1),
      string.sub(profiles_name[i],string.find(profiles_name[i],"__") + 2,string.len(profiles_name[i])))
    end
    return profiles
  else
    return false
  end
end

-- Remove a profile
-- @param filename representing the name of the profile to remove
-- @return true representing remove successfully
-- @return false representing remove unsuccessfully
-- @usage
-- --if localprofilemanager:remove("Anna") then
-- --  -- remove success
-- --else
-- --  -- remove fail
-- --end
function localprofilemanager:delete(profile_city,profile_email)
  local path = utils.absolute_path("data/profile/")

  for file in lfs.dir(path) do
    if string.match(file,string.format("%s__%s",profile_city,profile_email)) ~= nil then
      local thefile = utils.absolute_path(string.format("data/profile/%s__%s.profile", profile_city,profile_email))

      if(lfs.attributes(thefile, "mode") ~= "directory") then
        resultOK, errorMsg = os.remove(thefile)
        if resultOK then
          return true
        else
          return false
        end
      end
    end
  end
end

-- Synchronize json content from server to local profile
-- @param server_json_profile representing the string get from server
-- @return profile representing the instance of profile based on server json data
function localprofilemanager:synchronizetolocal(server_json_profile)
  local name, email_address, date_of_birth
  local sex, city, balance, experience
  local id, password, login_token
  local badges = {}
  local inventory = {}
  local server_profile = {}

  table.insert(server_profile,utils.split(server_json_profile,"\n"))
  for i = 1, #server_profile, 1 do
    if string.match(server_profile[i],"\"name\"") ~= nil then
      local tmp = {}
      tmp = utils.split(server_profile[i]," ")
      _,_,_,name = string.find(tmp[2],"([\"'])(.-)%1")
    end

    if string.match(server_profile[i],"\"email_address\"") ~= nil then
      local tmp = {}
      tmp = utils.split(server_profile[i]," ")
      _,_,_,email_address = string.find(tmp[2],"([\"'])(.-)%1")
    end

    if string.match(server_profile[i],"\"date_of_birth\"") ~= nil then
      local tmp = {}
      tmp = utils.split(server_profile[i]," ")
      _,_,_,date_of_birth = string.find(tmp[2],"([\"'])(.-)%1")
    end

    if string.match(server_profile[i],"\"sex\"") ~= nil then
      local tmp = {}
      tmp = utils.split(server_profile[i]," ")
      _,_,_,sex = string.find(tmp[2],"([\"'])(.-)%1")
    end

    if string.match(server_profile[i],"\"city\"") ~= nil then
      local tmp = {}
      tmp = utils.split(server_profile[i]," ")
      _,_,_,city = string.find(tmp[2],"([\"'])(.-)%1")
    end

    if string.match(server_profile[i],"\"balance\"") ~= nil then
      balance = tonumber(string.sub(server_profile[i],string.find(server_profile[i]," ") + 1,string.find(server_profile[i],",") - 1))
    end

    if string.match(server_profile[i],"\"experience\"") ~= nil then
      experience = tonumber(string.sub(server_profile[i],string.find(server_profile[i]," ") + 1,string.find(server_profile[i],",") - 1))
    end

    if string.match(server_profile[i],"\"badges\"") ~= nil then
      badges = utils.split(string.sub(server_profile[i],string.find(server_profile[i],"[") + 1, string.find(server_profile[i],"]") - 1),",")
    end

    if string.match(server_profile[i],"\"password\"") ~= nil then
      local tmp = {}
      tmp = utils.split(server_profile[i]," ")
      _,_,_,password = string.find(tmp[2],"([\"'])(.-)%1")
    end

    if string.match(server_profile[i],"\"login_token\"") ~= nil then
      local tmp = {}
      tmp = utils.split(server_profile[i]," ")
      _,_,_,login_token = string.find(tmp[2],"([\"'])(.-)%1")
    end

    if string.match(server_profile[i],"\"id\"") ~= nil then
      id = tonumber(string.sub(server_profile[i],string.find(server_profile[i]," ") + 1,string.find(server_profile[i],",") - 1))
    end

    if string.match(server_profile[i],"\"inventory\"") ~= nil then
      local tmp = {}
      tmp = utils.split(string.sub(server_profile[i],string.find(server_profile[i],"{") + 1, string.find(server_profile[i],"}") - 1),",")
      for i=1, #tmp, 1 do
        inventory[string.format("%s",sting.sub(tmp[i],1, string.find(tmp[i],":") - 1))] = tonumber(string.sub(tmp[i],string.find(tmp[i], " ") + 1, string.len(tmp[i])))
      end
    end

  end

  profile = Profile(name,email_address,date_of_birth,sex,city)
  profile:set_balance(balance)
  profile:set_experience(experience)
  profile:set_id(id)
  profile:set_password(password)
  profile:set_badges(badges)
  profile:set_inventory(inventory)
  profile:set_login_token(login_token)

  return profile
end
return localprofilemanager
