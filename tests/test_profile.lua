local luaunit = require("luaunit")
local class = require("lib.classy")
local Profile = require("lib.profile.Profile")
local TestProfile = {}

--Sets up test by creating a test object
function TestProfile:setUp()
<<<<<<< HEAD
  profile = Profile("HuanyuLi","lihuanyuasas@163.com","1992-06-29","male")
=======
  self.profile = Profile("HuanyuLi","lihuanyuasas@163.com","1992-06-29","male")
>>>>>>> 830c0c11449da0bc4854ed599dba12ed542073f0
end

function TestProfile:test_set_balance()
  luaunit.assertEquals(self.profile:set_balance(100), self.profile.balance)
end
function TestProfile:test_set_experience()
  luaunit.assertEquals(self.profile:set_experience(1000), self.profile.experience)
end
<<<<<<< HEAD
=======
function TestProfile:test_get_password()
  luaunit.assertEquals(self.profile:set_password("1q2w3e4r"), self.profile.password)
end
>>>>>>> 830c0c11449da0bc4854ed599dba12ed542073f0
function TestProfile:test_modify_balance()
  luaunit.assertEquals(self.profile:modify_balance(10), self.profile.balance)
end
function TestProfile:test_modify_experience()
  luaunit.assertEquals(self.profile:modify_experience(100), self.profile.experience)
end
return TestProfile
