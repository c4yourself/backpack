local luaunit = require("luaunit")
local event = require("lib.event")
local utils = require("lib.utils")

local TestEvent = {}

function TestEvent:setUp()
	self.event = event.Event()

	self.callback_data = nil
	self.callback = function(...)
		self.callback_data = {...}
	end
end

-- Test that default values are set to expected values
function TestEvent:test_callback_mock()
	luaunit.assertNil(self.callback_data, {1, 2, 3})

	self.callback(1, 2, 3)
	luaunit.assertEquals(self.callback_data, {1, 2, 3})

	self.callback(4, 5, 6)
	luaunit.assertEquals(self.callback_data, {4, 5, 6})
end

function TestEvent:test_trigger()
	self.event:on("test_event", self.callback)

	self.event:trigger("test_other_event")
	luaunit.assertNil(self.callback_data)

	self.event:trigger("test_event")
	luaunit.assertEquals(self.callback_data, {})

	self.event:trigger("test_event", 1, 2, 3)
	luaunit.assertEquals(self.callback_data, {1, 2, 3})

	self.event:trigger("test_event", 4, 5, 6)
	luaunit.assertEquals(self.callback_data, {4, 5, 6})
end

function TestEvent:test_off()
	self.event:on("test_event", self.callback)
	self.event:off("test_event", self.callback)
	self.event:trigger("test_event")
	luaunit.assertNil(self.callback_data)
end

function TestEvent:test_off_precision()
	self.event:on("test_event", self.callback)

	self.event:off("test_other_event")
	self.event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil

	self.event:off(function() end)
	self.event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil

	self.event:off("test_other_event", function() end)
	self.event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil

	self.event:off("test_event", function() end)
	self.event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil

	self.event:off("test_other_event", self.callback)
	self.event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil
end

function TestEvent:test_off_optional_arguments()
	self.event:on("test_event", self.callback)

	self.event:off(self.callback)
	self.event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:on("test_event", self.callback)
	self.event:off("test_event")
	self.event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:on("test_event", self.callback)
	self.event:off(self.callback)
	self.event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:on("test_event", self.callback)
	self.event:off()
	self.event:trigger("test_event")
	luaunit.assertNil(self.callback_data)
end

function TestEvent:test_once()
	self.event:once("test_event", self.callback)

	self.event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil

	self.event:trigger("test_event")
	luaunit.assertNil(self.callback_data)
end

function TestEvent:test_listening_to()
	local remote_event = event.Event()
	self.event:listen_to(remote_event, "test_event", self.callback)

	remote_event:trigger("test_other_event")
	luaunit.assertNil(self.callback_data)

	remote_event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
end

function TestEvent:test_stop_listening()
	local remote_event = event.Event()

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening(remote_event, "test_event", self.callback)
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening(remote_event, "test_event")
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening(remote_event)
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening()
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)
end

function TestEvent:test_stop_listening_precision()
	local remote_event = event.Event()
	self.event:listen_to(remote_event, "test_event", self.callback)

	self.event:stop_listening(remote_event, "test_event", function() end)
	remote_event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil

	self.event:stop_listening(remote_event, "test_other_event", self.callback)
	remote_event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil

	self.event:stop_listening(self.event, "test_event", self.callback)
	remote_event:trigger("test_event")
	luaunit.assertNotNil(self.callback_data)
	self.callback_data = nil
end

function TestEvent:test_stop_listening_optional_arguments()
	local remote_event = event.Event()

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening(remote_event)
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening("test_event")
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening(self.callback)
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)

	self.event:listen_to(remote_event, "test_event", self.callback)
	self.event:stop_listening("test_event", self.callback)
	remote_event:trigger("test_event")
	luaunit.assertNil(self.callback_data)
end

return TestEvent
