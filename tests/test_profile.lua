local luaunit = require("luaunit")
local class = require("lib.classy")
local Profile = require("lib.profile.Profile")
local TestProfile = {}

--Sets up test by creating a test object
function TestProfile:setUp()
  profile = TestProfile("HuanyuLi","lihuanyuasas@163.com","1992-06-29","male")
end

function TestProfile:test_set_balance()
  luaunit.assertEquals(profile:set_balance(100), profile.balance)
end
function TestProfile:test_set_experience()
  luaunit.assertEquals(profile:set_experience(1000), profile.experience)
end
function TestProfile:test_set_password()
  luaunit.assertEquals(profile:set_password("1q2w3e4r"), profile.password)
end
function TestProfile:test_modify_balance()
  luaunit.assertEquals(profile:modify_balance(10), profile.balance)
end
function TestProfile:test_modify_experience()
  luaunit.assertEquals(profile:modify_experience(100), profile.experience)
end
return TestProfile
