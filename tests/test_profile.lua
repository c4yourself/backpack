local luaunit = require("luaunit")
local class = require("lib.classy")
local Profile = require("lib.profile.Profile")
local TestProfile = {}


function TestProfile:setUp()

  self.profile = Profile("HuanyuLi","lihuanyuasas@163.com","1992-06-29","male","lodon")
end
function TestProfile:test_get_name()
  luaunit.assertEquals(self.profile:get_name(),"HuanyuLi")
end
function TestProfile:test_get_profile_name()
  luaunit.assertEquals(self.profile:get_profile_name(),"lodon__lihuanyuass@163.com")
end
function TestProfile:test_get_email_address()
  luaunit.assertEquals(self.profile:get_email_address(),"lihuanyuass@163.com")
end
function TestProfile:test_set_balance()
  luaunit.assertEquals(self.profile:set_balance(100), self.profile.balance)
end
function TestProfile:test_set_experience()
  luaunit.assertEquals(self.profile:set_experience(1000), self.profile.experience)
end
function TestProfile:test_modify_balance()
  luaunit.assertEquals(self.profile:modify_balance(10), self.profile.balance)
end
function TestProfile:test_modify_experience()
  luaunit.assertEquals(self.profile:modify_experience(100), self.profile.experience)
end
return TestProfile
