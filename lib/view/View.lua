--- Base class for View
-- @classmod View

local class = require("lib.classy")
local Event = require("lib.event.Event")
local logger = require("lib.logger")
local utils = require("lib.utils")

local View = class("View", Event)

View.log = true

--- Constructor for View
function View:__init()
	Event.__init(self)
	self.views = {}
	self._dirty = true
end

--- Add a view as a child view to this view. Note that this does not mean it is
-- rendered automatically when this view is rendered.
-- @param view View to add
-- @param propagate_dirty If true dirty events triggered by child view propagates
--                        upwards by marking this view as dirty.
function View:add_view(view, propagate_dirty)
	table.insert(self.views, view)

	if propagate_dirty then
		self:listen_to(view, "dirty", utils.partial(self.dirty, self))
	end
end

--- Remove a view as a child view to this view
-- @param view View that shall be removed
function View:remove_view(view)
	for i, v in ipairs(self.views) do
		if v == view then
			table.remove(self.views, i)
			break
		end
	end

	self:stop_listening(view)
	view:destroy()
end

--- Destroys the view and all child views and stops listening to events.
function View:destroy()
	if View.log then
		logger.trace("Destroying view " .. class.name(self))
	end

	for i = 1, #self.views do
		local view = self.views[i]
		view:destroy()
	end
	self:stop_listening()
end

--- Checks if the view or child views is dirty
-- @param[opt] deep True if child views should influence this View's dirty status
-- @return boolean
function View:is_dirty(deep)
	if self._dirty then
		return true
	end

	if not deep and deep ~= nil then
		return false
	end

	for i = 1, #self.views do
		local view = self.views[i]
		if view:is_dirty() then
			return true
		end
	end
	return false
end

--- Mark this View as being dirty, or unmark it.
-- This triggers the `dirty` event when marking as dirty.
-- @param[opt] status True (default) to mark View as dirty, otherwise unmark as dirty.
function View:dirty(status)
	-- Set default value of status
	if status == nil then
		status = true
	end

	local old_dirty = self._dirty
	self._dirty = status

	-- Only fire event if we are not dirty before
	if not old_dirty and self._dirty then
		self:trigger("dirty")
	end
end

--- Renders a view
-- NOTE: Must be overloaded by a subclass
-- @param surface {@Surface} or {@SubSurface} to render on
function View:render(surface)
	error("Render must be overloaded")
end


return View
