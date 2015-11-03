--- Base class for View
-- @classmod View

local class = require("lib.classy")
local Event = require("lib.event.Event")

local View = class("View", Event)

--- Constructor for View
function View:__init()
	self.views = {}
	self.dirty_flag = true
	Event.__init(self)
end


--- Destroys the view and all child views
function View:destroy()
	for i = 1, #self.views do
		local view = self.views[i]
		view:destroy()
	end
	self:stop_listening()
end

--- Checks if the view or child views is dirty
-- @return boolean
function View:is_dirty()
	if self.dirty_flag then
		return true
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

	local old_dirty = self.dirty_flag
	self.dirty_flag = status

	-- Only fire event if we are not dirty before
	if not old_dirty and self.dirty_flag then
		self:trigger("dirty")
	end
end

--- Renders a view
-- NOTE: Must be overloaded by a subclass
function View:render(surface)
	error("Render must be overloaded")
end


return View
