local luaunit = require("luaunit")
local class = require("lib.classy")
local Profile = require("lib.profile.Profile")
local localprofilemanager = require("lib.profile.localprofilemanager")
local Testlocalprofilemanager = {}


function Testlocalprofilemanager:setUp()
	self.profile = Profile("HuanyuLi","lihuanyuasas@163.com","1992-06-29","male","lodon")
end
return TestProfile
