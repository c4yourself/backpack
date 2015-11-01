--- Event class.
-- @classmod Event

local class = require("lib.classy")
local logger = require("lib.logger")
local utils = require("lib.utils")

local Event = class("Event")

--- Constructor for Event.
function Event:__init()
	self.event_callbacks = {}
	self.listening_to = {}
end

--- Bind a callback function to the given event type.
-- @param event_type Type of event to trigger callback function on.
-- @param callback Callback function to trigger on event type.
function Event:on(event_type, callback)
	logger.trace("Event listener added for " .. event_type)
	self:_on(event_type, callback, 0)
end

--- Works like on but the callback will trigger once.
-- @param event_type Type of event to trigger callback function on.
-- @param callback Callback function to trigger on event_type
function Event:once(event_type, callback)
	logger.trace("One time event listener added for " .. event_type)
	self:_on(event_type, callback, 1)
end

--- Triggers all callback functions bound to the event_type
-- @param event_type the acctual event_type.
-- @param[opt] ... Parameters to pass to callback functions.
function Event:trigger(event_type, ...)
	logger.trace("Event callbacks triggered for " .. event_type)

	if self.event_callbacks[event_type] == nil then
		logger.trace("No callbacks bound for " .. event_type)
		return
	end

	callbacks = {}
	for callback, callback_type in pairs(self.event_callbacks[event_type]) do
		callbacks[callback] = callback_type
	end

	for callback, callback_type in pairs(callbacks) do
		callback(...)

		-- If callback type is once, then it must be removed after being called
		if callback_type == 1 then
			callbacks[callback] = nil
		end
	end
end

--- Unbind a listener.
-- Prevents this callback from triggering again. Any parameter may be omitted.
-- @param[opt] event_type Event type to trigger on.
-- @param[opt] callback Callback function to run on trigger.
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

--- Make this object listen to triggers on another event object.
-- @param object Object to listen on.
-- @param event_type Event type to listen on.
-- @param callback Callback function to call when event type is triggered.
function Event:listen_to(object, event_type, callback)
	self:_listen_to(object, event_type, callback, 0)
end

--- Works like listen_to, but the callback will trigger once.
-- @param object Object to listen on.
-- @param event_type Event type to listen on.
-- @param callback Callback function to call when event type is triggered.
function Event:listen_to_once(object, event_type, callback)
	self:_listen_to(object, event_type, callback, 1)
end

--- Unbind a listener.
-- Any parameter may be left out.
-- @param[opt] object Object that this object should listen on.
-- @param[opt] event_type Event type to trigger on.
-- @param[opt] callback Callback function to run on trigger.
function Event:stop_listening(object, event_type, callback)
	-- Guess what arguments that were provided since all are optional
	if type(object) == "string" then
		object = nil
		event_type = object
		callback = nil
	elseif type(object) == "function" then
		callback = object

		object = nil
		event_type = nil
	end

	if type(event_type) == "function" then
		callback = event_type

		object = nil
		event_type = nil
	end

	-- If not object was given, default to all objects
	local objects = {object}
	if object == nil then
		objects = utils.keys(self.listening_to)
	end

	for _, obj in ipairs(objects) do
		-- If no event type was given, default to all event types
		local event_types = {event_type}
		if event_type == nil then
			event_types = utils.keys(self.listening_to[obj])
		end

		for _, et in ipairs(event_types) do
			-- If no callback was given, default to all callbacks
			local callbacks = {callback}
			if callback == nil then
				callbacks = utils.keys(self.listening_to[obj][et])
			end

			for _, cb in ipairs(callbacks) do
				obj:off(et, cb)
			end
		end
	end
end

--- Internal function for binding callbacks.
-- @param event_type Event type to trigger on
-- @param callback Callback function to run on trigger
-- @param callback_type 0 if callback is permanent, 1 for once only
-- @local
function Event:_on(event_type, callback, callback_type)
	if self.event_callbacks[event_type] == nil then
		self.event_callbacks[event_type] = {}
	end

	self.event_callbacks[event_type][callback] = callback_type
end

--- Internal function for binding callbacks.
-- @param object Object to listen on
-- @param event_type Event type to trigger on
-- @param callback Callback function to run on trigger
-- @param callback_type 0 if callback is permanent, 1 for once only
-- @local
function Event:_listen_to(object, event_type, callback, callback_type)
	if self.listening_to[object] == nil then
		self.listening_to[object] = {}
	end

	if self.listening_to[object][event_type] == nil then
		self.listening_to[object][event_type] = {}
	end

	self.listening_to[object][event_type][callback] = callback_type

	object:_on(event_type, callback, callback_type)
end

return Event
