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

-- Tests if the is_dirty function returns false when the view and
-- all childviews are not dirty
function TestView:test_is_dirty_when_clean()
	-- Set up a clean view hiearchy
	self.view.dirty_flag = false
	local view1 = View()
	local view2 = View()
	view1.dirty_flag = false
	view2.dirty_flag = false
	self.view.views = {view1, view2}
	-- Run test
	luaunit.assertEquals(self.view:is_dirty(), false)
end

-- Tests if the is_dirty function returns true when a childview is
-- dirty
function TestView:test_is_dirty_when_dirty()
	-- Set up a dirty view hiearchy
	self.view.dirty_flag = false
	local view1 = View()
	local view2 = View()
	view1.dirty_flag = false
	view2.dirty_flag = true
	self.view.views = {view1, view2}
	-- Run test
	luaunit.assertEquals(self.view:is_dirty(), true)
end

-- Makes sure View:render() function throws an error when called
function TestView:test_render()
	luaunit.assertEquals(pcall(self.view.render), false)
end

return TestView
