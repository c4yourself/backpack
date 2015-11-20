
local class = require("lib.classy")
local View = require("lib.view.View")
local view = require("lib.view")
local event = require("lib.event")
local surface = require("emulator.surface")
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local button_grid	=	require("lib.components.ButtonGrid")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local serpent = require("lib.serpent")
local Button = require("lib.components.Button")
local Profile = require("lib.profile.Profile")

local PopUp = class("PopUp",View)

function PopUp:__init(remote_control,surface, type)
	View:__init(self)
	self.popup_button_grid = button_grid(remote_control)

	local width = screen:get_width() * 0.5
	local height = (screen:get_height()-50) * 0.5

	self.type = type
	self.message_font = Font("data/fonts/DroidSans.ttf",20, Color(0,0,0,255))
	self.button_font = Font("data/fonts/DroidSans.ttf",25, Color(0,0,0,255))

	self.button_size = {width = 100, height = 100}

	self.button_color = Color(255,90,0,255)
	self.color_selected = Color(255,153,0,255)
	self.color_disabled = Color(0,0,0,255)

	if self.type == "message" then
		self:_create_message_buttons()
	else
		self:_create_confirmation_buttons()
	end

	local text_height = 50

	local callback = utils.partial(self.load_view, self)
	self:listen_to(
	event.remote_control,
	"button_release",
	callback
	)

	local button_callback = function()
		self.popup_button_grid:render(surface)
		gfx.update()
	end

	--might be a problem with this?
	self:listen_to(
		self.popup_button_grid,
		"dirty",
		button_callback
		)
end

function PopUp:_create_message_buttons()
	local button_ok = Button(self.button_color,self.color_selected,self.color_disabled,true,false)
	button_ok:set_textdata("Ok",self.color_disabled, {x=200, y=200},16, utils.absolute_path("data/fonts/DroidSans.ttf"))

	self.popup_button_grid:add_button({x = 50, y = 100}, self.button_size, button_ok)
end

function PopUp:_create_confirmation_buttons()
end

function PopUp:render(surface)
	surface:fill({r=255, g=255, b=255, a=255})

	local height = surface:get_height()
	local width = surface:get_width()
	local text_indent = 100 -- Indents text area

	-- Draw the fonts
	self.message_font:draw(surface, {x = height/6-10, y = 20}, "Message")
--	city_tour_attraction_font:draw(surface, {x = height/6, y = height*23/30+5, width = height*0.54*3/5, height = 30}, "Message2", center)

	-- Draw tour text square x-axis
	--surface:fill({0,0,0,255}, {width = 2/3*width-150, height = 2, x = width/3+95, y =45})

	--Write all the tour text
	--city_tour_text:draw(surface, {x = width/3+text_indent, y = 50+25*i, width = text_width, height = 25}, "hej", nil, nil)

	--Render buttons
	self.popup_button_grid:render(surface)
	print("var i citytour")
	--self:trigger("exit_view")
end

return PopUp
