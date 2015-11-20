local class = require("lib.classy")
local luaunit = require("luaunit")
local View = require("lib.view.View")
local ViewManager = require("lib.view.ViewManager")

local TestViewManager = {}

-- Sets up tests
function TestViewManager:setUp()
	view_manager = ViewManager()
end

-- Tests that destroy is called in cojunction with ViewManager:set_view is
-- called
function TestViewManager:test_set_view()
	-- Create a mock view represented by a table
	local test_view = View()

	test_view.destroy_flag = false
	function test_view:destroy()
		self.destroy_flag = true
	end
	function test_view:render()
	end

	-- Run test
	view_manager:set_view(test_view)
	view_manager:set_view(test_view)
	luaunit.assertEquals(test_view.destroy_flag, true)
end

return TestViewManager
