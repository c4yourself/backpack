--- Base class for NumericQuestion
-- @classmod NumericQuestion

local class = require("lib.classy")
local Event = require("lib.event.Event")

local View = class("View", Event)

--- Constructor for View
-- @param image_path path to the image as a string
-- @param question string representing a mathematical expression
-- @param correct_answer number representing the correct answer
function View:__init()
	View.views = {}
	Event.__init(self)
end


--- Destroys view and all childviews
function View:destroy()
	for i = 1, #self.views do
		local view = self.views[i]
		view:destroy()
	end
	--TODO
	--self:stop_listening()
end

function View:is_dirty()
end

function View:render(surface)
end


return View
