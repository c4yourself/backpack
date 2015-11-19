--- Base class for TestKeyboardView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod TestKeyboardView

local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local TestKeyboardView = class("TestKeyboardView", View)
local event = require("lib.event")
local utils = require("lib.utils")
local SubSurface = require("lib.view.SubSurface")
local button= require("lib.components.Button")
local button_grid	=	require("lib.components.ButtonGrid")
local KeyboardComponent	=	require("components.KeyboardComponent")
local InputField	=	require("components.InputField")
local color = require("lib.draw.Color")
local logger = require("lib.logger")

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function TestKeyboardView:__init(remote_control)
	View.__init(self)
	self.background_path = ""
	input_field = InputField("name", {x = 700, y = 80}, true)
	--input_field2 = InputField("name", {x = 700, y = 230}, true)
end

function TestKeyboardView:render(surface)
	-- -- Resets the surface and draws the background
	local background_color = {r=255, g=255, b=255}
	surface:clear(background_color)
	input_field:render(surface)

	-- --surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris.png")))
	--
	-- local log_in_button = sys.new_freetype({r=23, g=155, b=23}, 30, {x=700+50,y=35}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	-- surface:fill({r=23, g=0, b=23}, {width=500, height=100, x=700, y=45})
	-- log_in_button:draw_over_surface(surface, "Ok")
	--
	-- local input = sys.new_freetype({r=23, g=155, b=23}, 30, {x=700+50,y=135}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	-- input:draw_over_surface(surface, "namn: ")
	--
	-- keyboard = KeyboardComponent()
	-- keyboard:render(surface)
	-- --logger:trace("active:" .. keyboard:is_active())
	-- if keyboard:is_active() then
	-- 	logger:trace("keyboard ACTIVE")
	-- else
	-- 	logger:trace("keyboard is not active")
	-- end

	--keyboard:set_active(false)
	local callback = utils.partial(self.load_view, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		callback
		--utils.partial(self.load_view, self)
	)


end

function TestKeyboardView:load_view(button)
	-- TODO set mappings to RC
	if (keyboard:is_active()) then
		keyboard:button_press(button)
	else
		logger:trace("regular bindings")
		--regular RC bindings
	end

end

return TestKeyboardView
