--- Event module
-- @module event
local event = {}

--- @{Event} class
event.Event = require("lib.event.Event")

--- Global @{Event} instance for remote control input.
-- When a button is pressed down `button_press` is triggered. While a button is
-- pressed down `button_repeat` is triggered. When a button is pressed released
-- `button_release` is triggered.
event.remote_control = event.Event()

return event
