--- Base class for ViewManager
--
-- There will be one instance of the ViewManager available from the view module
-- as window. This global instance is used by modules to change the currently
-- active View.
-- @classmod ViewManager

local class = require("lib.classy")
local ViewManager = class("ViewManager")

--- Constructor for ViewManager
-- @param surface Surface that views will be rendered on
-- @param view top-level view component
function ViewManager:__init(surface, view)
	self.surface = surface
	self.view = view
end

--- Sets a view as the active view for this ViewManager, destroys the previous
-- view and renders the new view
function ViewManager:set_view(view)
	if self.view ~= nil then
		self.view.destroy()
	end
	self.view = view
	self.view.render()
end

--- Returns the currently active view
-- @Returns view Current top-level view component for this ViewManager
function ViewManager:get_view(view)
	return self.view
end

--- Renders the currently active view and all its child views
-- @throws Exception if there's no active view
function ViewManager:render()
	if self.view == nil then
		error("Error: No active view coupled with the ViewManager")
	end
	self.view.render(self.surface)
end

return ViewManager
