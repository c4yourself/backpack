local class = require("lib.classy")
local luaunit = require("luaunit")
local View = require("lib.view.View")
local event = require("lib.event")

local TestView = {}

function TestView:setUp()
	self.view = View()
end

-- Test that default values are set to expected values
function TestView:test_defaults()
	luaunit.assertEquals(self.view:is_dirty(), true)
end

-- Tests if the is_dirty function returns false when the view and
-- all childviews are not dirty
function TestView:test_is_dirty_when_clean()
	-- Set up a clean view hiearchy
	local view1 = View()
	local view2 = View()

	self.view:dirty(false)
	view1:dirty(false)
	view2:dirty(false)

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

	self.view:dirty(false)
	view1:dirty(false)
	view2:dirty(true)

	self.view.views = {view1, view2}
	-- Run test
	luaunit.assertEquals(self.view:is_dirty(), true)
end

-- Make sure that dirty marks view dirty and fires event
function TestView:test_dirty()
	self.view:dirty(false)
	luaunit.assertFalse(self.view:is_dirty())

	local call_count = 0
	function incr()
		call_count = call_count + 1
	end

	self.view:on("dirty", incr)
	self.view:dirty()

	luaunit.assertTrue(self.view:is_dirty())
	luaunit.assertEquals(call_count, 1)

	self.view:dirty()
	luaunit.assertEquals(call_count, 1)

	self.view:dirty(false)
	self.view:dirty()
	luaunit.assertEquals(call_count, 2)
end

-- Makes sure View:render() function throws an error when called
function TestView:test_render()
	luaunit.assertEquals(pcall(self.view.render), false)
end

-- Tests if the View:destroy() function works for a parent view
function TestView:test_destroy_parent()
	local remote_event = event.Event()
	self.view:listen_to(remote_event, "test_event", function() error() end)
	self.view:destroy()
	remote_event:trigger("test_event")
end

--Tests if View:destroy() also makes child views stop listening
function TestView:test_destroy_child_views()
	local remote_event = event.Event()
	local view1 = View()
	local view2 = View()
	self.view.views = {view1, view2}

	view2:listen_to(remote_event, "test_event", function() error() end)
	self.view:destroy()
	remote_event:trigger("test_event")
end

function TestView:test_dirty_event_propagation()
	local top = View()
	local middle = View()
	local bottom = View()
	local bottom_unpropagated = View()

	top:dirty(false)
	middle:dirty(false)
	bottom:dirty(false)
	bottom_unpropagated:dirty(false)

	top:add_view(middle, true)
	middle:add_view(bottom, true)
	bottom:add_view(bottom_unpropagated)

	local is_dirty = false
	top:on("dirty", function()
		is_dirty = true
	end)

	bottom_unpropagated:dirty()
	luaunit.assertFalse(is_dirty)

	bottom:dirty()
	luaunit.assertTrue(is_dirty)
end

return TestView
