local class = require("lib.classy")
local luaunit = require("luaunit")
local View = require("lib.view.View")

local TestView = {}

function TestView:setUp()
	self.view = View()
end

-- Test that default values are set to expected values
function TestView:test_defaults()
	luaunit.assertEquals(self.view.dirty_flag, true)
end

return TestView
