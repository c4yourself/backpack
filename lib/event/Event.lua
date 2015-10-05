--- Event class
-- @classmod Event

local class = require("lib.classy")

local Event = class("Event")

--- Constructor for Event.
-- The constructor only creates the list for the remote control events at this stage,
-- it has to be general and have lists for all types of events
function Event:__init()
	self.event_callbacks = {}
end


--- Create On Event listener
-- This function adds a listener to the Event and stores a connected callback function
function Event:on(event_type, callback)
	if (self.event_callbacks[event_type] == nil) then
		self.event_callbacks[event_type] = {}
	end
	table.insert(self.event_callbacks[event_type],callback)
end


--- Triggers all callbacks connected to the event_type
function Event:trigger(event_type, ...)
	-- var args, tillåter att skicka med okänt antal argument
	-- print("list length: " .. #self.event_callbacks[event_type])
	print("event_type: " .. event_type)
	-- samma inargument för en button_press, får första
	--print("antal element: " .. select('#', ...))
	for index, value in ipairs(self.event_callbacks[event_type]) do
		value(...)
		--for n=1, select('#', ...) do
		--	local e = select(n,...)
		--end
		--a = select(1,...)
	end
end

-- Remove On Event listener
-- This function removes an On-listener to the Event
-- function Event:off(event_type, callback)
--	table.remove(self.event_callbacks[event_type])
-- end


return Event

-- remote_control = Event()
-- remote_control.on("button_press", function(button) print("Button " .. button) end)
-- remote_control.trigger("button_press", "exit")
-- => Button exit
