--- Event class
-- @classmod Event

local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")

local Event = class("Event")

--- Constructor for Event.
-- The constructor only creates the list for the remote control events at this stage,
-- it has to be general and have lists for all types of events
function Event:__init()
	self.event_callbacks = {}
end


function Event:_on(event_type, callback, callback_type)
	if (self.event_callbacks[event_type] == nil) then
		self.event_callbacks[event_type] = {}
	end

	self.event_callbacks[event_type][callback] = callback_type
end

--- Create On Event listener
-- stores a callback function to an event_type
-- @param event_type this is the event type that the callback function will be conneted to
-- @param callback this is the stored funciton which the trigger function will execute
function Event:on(event_type, callback)
	logger.trace("Event listener added for " .. event_type)

	self:_on(event_type, callback, 0)
end

-- preform the on function and then remove the event listner
function Event:once(event_type, callback)
	logger.trace("One time event listener added for " .. event_type)

	self:_on(event_type, callback, 1)
end

--- Triggers all callback functions connected to the event_type
-- @param event_type the acctual event_type
-- @param ... this is the parameters for the callback functions
function Event:trigger(event_type, ...)
	logger.trace("Event callbacks triggered for " .. event_type)

	if self.event_callbacks[event_type] == nil then
		logger.trace("No callbacks bound for " .. event_type)
		return
	end

	for callback, callback_type in pairs(self.event_callbacks[event_type]) do
		callback(...)

		-- If callback type is once, then it must be removed after being called
		if callback_type == 1 then
			self.event_callbacks[event_type][callback] = nil
		end
	end
end

-- Remove listener.
-- This function removes an On-listener to the Event
--
-- @param[opt] event_type Type to unbind listeners from
-- @param[opt] callback Callback function to remove
function Event:off(event_type, callback)
	-- Since both arguments are optional, we must check if event_type is actually
	-- a callback function.
	if type(event_type) == "function" then
		callback = event_type
		event_type = nil
	end

	-- Make list of event types to remove callbacks from
	local event_types = {event_type}
	if event_type == nil then
		event_types = utils.keys(self.event_callbacks)
	end

	logger.trace(
		"Event listener are removed for " .. table.concat(event_types, ", "))

	-- Iterate through all callbacks and remove the ones matching the arguments
	for i, et in ipairs(event_types) do
		if self.event_callbacks[et] then
			for cb, _ in pairs(self.event_callbacks[et]) do
				if callback == nil or callback == cb then
					self.event_callbacks[et][cb] = nil
				end
			end
		end
	end
end

return Event
