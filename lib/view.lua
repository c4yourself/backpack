--- View module
-- @module view
local view = {}

--- @{View} class
view.View = require("lib.view.View")
view.ViewManager = require("lib.view.ViewManager")

--- Global @{View} instance for access to the @{ViewManager}.
-- The View Manager is used for swithching views by using set_view(view) and
-- for rendering the current view (using render())
view.view_manager = view.ViewManager()
view.view_manager:on("render", gfx.update)

return view
