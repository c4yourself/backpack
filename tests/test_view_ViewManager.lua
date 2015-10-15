local class = require("lib.classy")
local luaunit = require("luaunit")
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
	local mockView
	mockView = {destroy = function() mockView.destroy_flag = true end; render =function() end; destroy_flag = false}

	-- Run test
	--view_manager = ViewManager()
	view_manager:set_view(mockView)
	view_manager:set_view(mockView)
	--print(mockView.destroy())
	print(mockView.destroy_flag)
	luaunit.assertEquals(mockView.destroy_flag, true)
end

return TestViewManager
