
--- Base class for SplashView
-- SplashView is the View that shows as the box starts up
-- @classmod SplashView

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local logger = require("lib.logger")
local Rectangle = require("lib.draw.Rectangle")
local utils = require("lib.utils")
local view = require("lib.view")

local SplashView = class("SplashView", view.View)

--- Constructor for SplashView
-- @param event_listener Remote control to listen to
function SplashView:__init(image_path, target_view, view_manager)
	view.View.__init(self)

	local absolute_path = utils.absolute_path(image_path)
	logger.trace("Loading image", absolute_path)

	self.splash_image = gfx.loadpng(image_path)
	self.target_view = target_view
	self.view_manager = view_manager

	self.background_color = Color(255, 255, 255, 255)
	self.current_opacity = 0
	self.opacity_step = 5
end

function SplashView:destroy()
	view.View.destroy(self)

	self.splash_image:destroy()
	self.timer = nil
end

function SplashView:start(tick_rate)
	self.timer = sys.new_timer(tick_rate, function()
		self.current_opacity = math.min(
			self.current_opacity + self.opacity_step, 255)

		self:dirty()

		if self.current_opacity == 255 then
			self.timer:stop()
			self.view_manager:set_view(self.target_view)
		end
	end)
end

function SplashView:render(surface)
	surface:clear(self.background_color:to_table())

	-- Calculate splash location and size
	local splash_rectangle = Rectangle.from_surface(self.splash_image):translate(
		surface:get_width() / 2 - self.splash_image:get_width() / 2,
		surface:get_height() / 2 - self.splash_image:get_height() / 2)

	surface:copyfrom(self.splash_image, nil, splash_rectangle:to_table())

	splash_rectangle:fill(surface, self.background_color:replace(
		{alpha = 255 - self.current_opacity}))

	self:dirty(false)
end

return SplashView
