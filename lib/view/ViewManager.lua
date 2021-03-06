--- Base class for ViewManager
--
-- There will be one instance of the ViewManager available from the view module
-- as window. This global instance is used by modules to change the currently
-- active View.
-- @classmod ViewManager

local class = require("lib.classy")
local Event = require("lib.event.Event")
local logger = require("lib.logger")
local utils = require("lib.utils")

local ViewManager = class("ViewManager", Event)

ViewManager.log = true

--- Constructor for ViewManager
-- @param surface Surface that views will be rendered on, defaults to screen
-- @param view top-level view component
function ViewManager:__init(surface, view)
	Event.__init(self)

	if surface == nil then
		self.surface = screen
	else
		self.surface = surface
	end

	if view ~= nil then
		self:set_view(view)
	end
end

--- Sets a view as the active view for this ViewManager, destroys the previous
-- view and renders the new view
-- @param view View instance that will become the new top level view
function ViewManager:set_view(view)
	if self.view ~= nil then
		if ViewManager.log then
			logger.trace("Destroying previous view " .. class.name(self.view))
		end

		self.view:destroy()
		self:stop_listening()
	end

	self.view = view
	self:listen_to(self.view, "dirty", utils.partial(self.render, self))
	self:render()
end

--- Returns the currently active view
-- @returns view Current top-level view component for this ViewManager
function ViewManager:get_view()
	return self.view
end

--- Renders the currently active view and all its child views
-- @throws Exception if there's no active view
function ViewManager:render()
	if self.view == nil then
		error("Error: No active view coupled with the ViewManager")
	end

	local start_time = os.clock()
	self.view:render(self.surface)

	if ViewManager.log then
		logger.debug(string.format(
			"Rendered in %.2f seconds, using %s",
			os.clock() - start_time,
			utils.human_size(gfx.get_memory_use())))
	end

	self:trigger("render", self)
end

return ViewManager
