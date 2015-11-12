local luaunit = require("luaunit")
local class = require("lib.classy")
local Profile = require("lib.profile.Profile")
local TestProfile = {}


function TestProfile:setUp()

  self.profile = Profile("HuanyuLi","lihuanyuasas@163.com","1992-06-29","male")
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
