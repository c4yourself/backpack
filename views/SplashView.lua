--- Base class for SplashView
-- A SplashView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod SplashView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local SplashView = class("SplashView", View)
local event = require("lib.event")
local utils = require("lib.utils")
local SubSurface = require("lib.view.SubSurface")
local NumericalQuizView = require("views.NumericalQuizView")
local button= require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local color = require("lib.draw.Color")
local logger = require("lib.logger")
local CityView2 = require("views.CityView2")

--- Constructor for SplashView
-- @param event_listener Remote control to listen to
function SplashView:__init(remote_control)
	View.__init(self)
	self.background_path = ""
end

function SplashView:render(surface)
	-- Resets the surface and draws the background
	local background_color = {r=255, g=255, b=255}
	surface:clear(background_color)
	-- print logo in center

	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/logo.png")),nil,{x=525,y=329})
	logo_fade_surface = SubSurface(surface,{width=280, height=62, x=525, y=329})
	logo_fade_surface:fill({r=255, g=255, b=255, a=255})
	gfx.update()
	fader = 0
	-- end_splash in 2 seconds.

	local callback = utils.partial(self.end_splash, self, surface)
	self.stop_timer = sys.new_timer(40,callback)
end

function SplashView:end_splash(surface)

	-- logger.trace(255-fader*7)
	--local city_view_2 = CityView2(event.remote_control)
	--view.view_manager:set_view(city_view_2)
	--gfx.update()
	if (fader < 10 ) then
		surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/logo.png")),nil,{x=525,y=329})
		logo_fade_surface:fill({r=255, g=255, b=255, a=(255-((fader*255)/10))})
		logger.trace("a = " .. fader)
		gfx.update()
	end
	surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/logo.png")),nil,{x=525,y=329})
	if(fader == 15) then
		self.stop_timer:stop()
		logger.trace("Ending Splash View")
		local city_view_2 = CityView2(event.remote_control)
		view.view_manager:set_view(city_view_2)
		gfx.update()
	end

	fader = fader + 1

end



return SplashView
