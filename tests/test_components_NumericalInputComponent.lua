local class = require("lib.classy")
local event = require("lib.event")
local luaunit = require("luaunit")
local NumericalInputComponent = require("components.NumericalInputComponent")

local TestNumericalInputComponent = {}

-- Sets up tests
function TestNumericalInputComponent:setUp()
	self.num_component = NumericalInputComponent()
end

-- Make sure the is_dirty flag is changed from false to true when set_text
-- is called
function TestNumericalInputComponent:test_set_flag()
	self.num_component.dirty_flag = false
	self.num_component:set_text("1337")
	luaunit.assertEquals(self.num_component.dirty_flag, true)
end

-- Test if the NumericalInputComponent responds to events after it has been
-- focused
function TestNumericalInputComponent:test_focus()
	self.num_component.test_trigger_flag = false
	self.num_component.focused = false
	self.num_component:focus()
	event.remote_control:trigger("button_press")
	luaunit.assertEquals(self.num_component.test_trigger_flag,true)
end

-- Test if the NumericalInputComponent stops responding to events after it has
-- been blurred
function TestNumericalInputComponent:test_blur()
	self.num_component.test_trigger_flag = false
	self.num_component.focused = true
	self.num_component:blur()
	event.remote_control:trigger("button_press")
	luaunit.assertEquals(self.num_component.test_trigger_flag,false)
end

-- Tests if an error is thrown when non-numeric input is fed to the component
function TestNumericalInputComponent:test_set_error()
	luaunit.assertEquals(pcall(self.num_component.set_text, "abc"), false)
end

return TestNumericalInputComponent
