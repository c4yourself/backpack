--- Event class
-- @classmod Event

local class = require("lib.classy")

local Event = class("Event")

--- Constructor for Event.
-- The constructor only creates the list for the remote control events at this stage,
-- it has to be general and have lists for all types of events
function Event:__init()
	self.event_callbacks = {
		button_press = {}
	}
end


--- Create On Event listener
-- stores a callback function to an event_type
-- @param event_type this is the event type that the callback function will be conneted to
-- @param callback this is the stored funciton which the trigger function will execute
function Event:on(event_type, callback)
	if (self.event_callbacks[event_type] == nil) then
		self.event_callbacks[event_type] = {}
	end
	table.insert(self.event_callbacks[event_type],callback)
end


--- Triggers all callback functions connected to the event_type
-- @param event_type the acctual event_type
-- @param ... this is the parameters for the callback functions
function Event:trigger(event_type, ...)

	print("event_type: " .. event_type)
	for index, value in ipairs(self.event_callbacks[event_type]) do
		value(...)
	end
end

function Event:once(event_type, callback)
--put stuff here

function Event:listen_to(object, event_type, callback)
--put stuff here

function Event:listen_to_once(object, event_type, callback)
--put stuff here

function Event:Stop_listening(object, event_type, callback)
--put stuff here


-- Remove On Event listener
-- This function removes an On-listener to the Event
-- function Event:off(event_type, callback)
	self.event_callbacks[event_type] = nil
--	table.remove(self.event_callbacks[event_type])
-- end


return Event

-- remote_control = Event()
-- remote_control.on("button_press", function(button) print("Button " .. button) end)
-- remote_control.trigger("button_press", "exit")
-- => Button exit
