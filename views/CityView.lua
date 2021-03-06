--- Base class for CityView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CityView

local Button = require("components.Button")
local ButtonGrid = require("components.ButtonGrid")
local class = require("lib.classy")
local CityTourView = require("views.CityTourView")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local event = require("lib.event")
local logger = require("lib.logger")
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local view = require("lib.view")
local PopUpView = require("views.PopUpView")
local ProfileManager = require("lib.profile.ProfileManager")
local TopBarView = require("views.TopBarView")
local CityView = class("CityView", view.View)

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityView:__init(profile, remote_control)
	view.View.__init(self)

	self.remote_control = remote_control or event.remote_control
	self.profile_manager = ProfileManager()
	self.background_path = ""
	--Instance of the  current profile, can be used to get name, sex etc
	self.profile = profile
	self.button_grid = ButtonGrid(self.remote_control)

	self.top_bar = TopBarView(self.profile)

	local text_color = Color(111, 189, 88, 255)
	-- Create some button colors
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255) --have not been used yet

	local city_view_selected_color = Color(1, 1, 1, 100)
	local city_view_color = Color(1, 1, 1, 0)

	-- Create some fonts to write with
	city_view_small_font = Font("data/fonts/DroidSans.ttf", 20, Color(255, 255, 255, 255))
	city_view_large_font = Font("data/fonts/DroidSans.ttf", 25, Color(255, 255, 255, 255))

	-- Creates local variables for height and width
	local height = screen:get_height()
	local width = screen:get_width()

	-- Add buttons
	local button_1 = Button(button_color, color_selected, color_disabled,true,true,"views.MultipleChoiceView")
	local button_2 = Button(button_color, color_selected, color_disabled,true,false, "views.NumericalQuizView")
	local button_3 = Button(button_color, color_selected, color_disabled,true,false, "views.MemoryView")
	local button_4 = Button(button_color, color_selected, color_disabled,true,false, "components.ConnectFourComponent")
	local button_5 = Button(button_color, color_selected, color_disabled,true,false, "views.Store")
	local button_6 = Button(button_color, color_selected, color_disabled,true,false, "views.ProfileView")
	local button_7 = Button(button_color, color_selected, color_disabled,true,false, "views.TravelView")
	local button_8 = Button(button_color, color_selected, color_disabled,true,false, "exit")
	local city_tour_button = Button(city_view_color, city_view_selected_color, color_disabled, true, false, "views.CityTourView")

	-- Define each button's posotion and size
	local button_size = {width = 4*width/45, height = 4*width/45}
	local position_1 = {x = 3*width/45, y = 100}
	local position_2 = {x = 8*width/45, y = 100}
	local position_3 = {x = 3*width/45, y = 100+5*width/45}
	local position_4 = {x = 8*width/45, y = 100+5*width/45}
	local position_5 = {x = 3*width/45, y = (height-50)/2+100}
	local position_6 = {x = 8*width/45, y = (height-50)/2+100}
	local position_7 = {x = 3*width/45, y = 5*width/45+(height-50)/2+100}
	local position_8 = {x = 8*width/45, y = 5*width/45+(height-50)/2+100}
	local city_tour_position = {x = width/3, y = 50}
	local city_tour_size = {width = 2*width/3-1, height = height-51}

	-- Add icon for city tour button
	city_tour_button:add_icon(
		"data/images/"..self.profile.city .. "Icon.png",
		"data/images/"..self.profile.city.."IconSelected.png",
		0, 0, city_tour_size.width, city_tour_size.height)

	-- Using the button grid to create buttons
	self.button_grid:add_button(position_1, button_size, button_1)
	self.button_grid:add_button(position_2, button_size, button_2)
	self.button_grid:add_button(position_3, button_size, button_3)
	self.button_grid:add_button(position_4, button_size, button_4)
	self.button_grid:add_button(position_5, button_size, button_5)
	self.button_grid:add_button(position_6, button_size, button_6)
	self.button_grid:add_button(position_7, button_size, button_7)
	self.button_grid:add_button(position_8, button_size, button_8)
	self.button_grid:add_button(city_tour_position, city_tour_size, city_tour_button)

	self:focus()

	-- Preload images for increased performance
	self.images = {
		background = gfx.loadpng("data/images/"..self.profile.city..".png"),

		math_icon = gfx.loadpng("data/images/MathIcon.png"),
		flight_icon = gfx.loadpng("data/images/FlightIcon.png"),
		exit_icon = gfx.loadpng("data/images/ExitIcon.png"),
		user_icon = gfx.loadpng("data/images/UserIcon.png"),
		memory_icon = gfx.loadpng("data/images/MemoryIcon.png"),
		store_icon = gfx.loadpng("data/images/StoreIcon.png"),
		four_in_a_row_icon = gfx.loadpng("data/images/4inRowIcon.png"),
		multiple_choice_icon = gfx.loadpng("data/images/MultipleChoiceIcon.png")
	}

	-- Premultiple images with transparency to make them render properly
	self.images.math_icon:premultiply()
	self.images.flight_icon:premultiply()
	self.images.flight_icon:premultiply()
	self.images.exit_icon:premultiply()
	self.images.user_icon:premultiply()
	self.images.memory_icon:premultiply()
	self.images.store_icon:premultiply()
	self.images.four_in_a_row_icon:premultiply()
	self.images.multiple_choice_icon:premultiply()

	self:add_view(self.button_grid, true)

	self:listen_to(
		self.button_grid,
		"button_click",
		utils.partial(self.button_click, self))
end

--- Action to take
function CityView:button_click(button)
	if not button.transfer_path then
		return
	elseif button.transfer_path == "exit" then
		self:exit_city_view()
		return
	end

	-- Blur this view to prevent it from reacting to button clicks
	self:blur()

	-- Create instance of the given view
	local view_class = require(button.transfer_path)
	local sub_surface = SubSurface(screen, {
		x = screen:get_width() * 0.04,
		y = screen:get_height() * 0.04 + 50,
		width = screen:get_width() * 0.92,
		height = (screen:get_height() - 50) * 0.92,
	})
	local view = view_class(self.remote_control, sub_surface, self.profile)

	-- Listen to when child view is closed
	self:listen_to_once(view, "exit_view", function()
		self:remove_view(view)
		self:focus()
		self.sub_view = nil
		self.profile_manager:save(self.profile)
		self:dirty()
	end)

	self:add_view(view, true)
	self.sub_view = view
	self:dirty()
end


-- Calls a pop up for exiting the city view to the profile
function CityView:exit_city_view()
	local type = "confirmation"
	local message =  {"Are you sure you want to exit the City View?"}
	local subsurface = SubSurface(screen,{width=screen:get_width()*0.5, height=(screen:get_height()-50)*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25+50})
	local popup_view = PopUpView(self.remote_control,subsurface, type, message)

	self:add_view(popup_view)
	self:blur()

	local button_click_func = function(button)
		if button == "ok" then
			local ProfileSelection = require("views.ProfileSelection")
			local profile_selection = ProfileSelection(self.remote_control)
			view.view_manager:set_view(profile_selection)
		else
			popup_view:destroy()
			self:focus()
			self:dirty(true)
			gfx.update()
		end
	end

	self:listen_to_once(popup_view, "button_click", button_click_func)
	popup_view:render(subsurface)
	gfx.update()
end

function CityView:blur()
	self.button_grid:blur()
	self:stop_listening(self.remote_control)
end

function CityView:focus()
	self:listen_to(
		self.remote_control,
		"button_release",
		utils.partial(self.load_view, self))
	self.button_grid:focus()
end

function CityView:render(surface)
	-- Creates local variables for height and width
	local height = surface:get_height()
	local width = surface:get_width()

	local city = self.profile:get_city()

	-- Resets the surface and draws the background
	local background_color = {r = 0, g = 0, b = 0}

	surface:clear(background_color)

	surface:copyfrom(self.images.background, nil, {x = 0, y = 50, width = width, height = height-51}, false)

	--creates some colors
	local text_color = Color(1, 1, 1, 255)
	local score_text_color = Color(255, 255, 255, 255)
	local menu_bar_color = Color(1, 1, 1, 225)
	local status_bar_color = Color(1, 1, 1, 255)
	local status_text_color = Color(255, 255, 255, 255)
	local experience_bar_color = Color(100, 100, 100, 255)

	-- Shows menu bar
	surface:fill(menu_bar_color:to_table(), {width=width/3, height=height-50, x=0, y=50})
	city_view_large_font:draw(surface, {x=width/6-65, y=60}, "Mini Games")
	city_view_large_font:draw(surface, {x=width/6-45, y=(height-50)/2+60}, "Options")

 	-- using the button grid to render all buttons and texts
	self.button_grid:render(surface)

	local icon_padding = self.button_grid.button_list[1].width/8
	surface:copyfrom(self.images.multiple_choice_icon, nil, {x = self.button_grid.button_list[1].x + icon_padding, y = self.button_grid.button_list[1].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)
	surface:copyfrom(self.images.math_icon, nil, {x = self.button_grid.button_list[2].x + icon_padding, y = self.button_grid.button_list[2].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)
	surface:copyfrom(self.images.memory_icon, nil, {x = self.button_grid.button_list[3].x + icon_padding, y = self.button_grid.button_list[3].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)
	surface:copyfrom(self.images.four_in_a_row_icon, nil, {x = self.button_grid.button_list[4].x + icon_padding, y = self.button_grid.button_list[4].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)
	surface:copyfrom(self.images.store_icon, nil, {x = self.button_grid.button_list[5].x + icon_padding, y = self.button_grid.button_list[5].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)
	surface:copyfrom(self.images.user_icon, nil, {x = self.button_grid.button_list[6].x + icon_padding, y = self.button_grid.button_list[6].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)
	surface:copyfrom(self.images.flight_icon, nil, {x = self.button_grid.button_list[7].x + icon_padding, y = self.button_grid.button_list[7].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)
	surface:copyfrom(self.images.exit_icon, nil, {x = self.button_grid.button_list[8].x + icon_padding, y = self.button_grid.button_list[8].y + icon_padding, width = self.button_grid.button_list[1].width - 2*icon_padding, height = self.button_grid.button_list[1].height - 2*icon_padding}, true)

	-- Insert current sub view on top in a popup window if there is any
	if self.sub_view then
		local sub_surface = SubSurface(surface, {
			x = surface:get_width() * 0.04 - 5,
			y = surface:get_height() * 0.04 + 50 - 5,
			width = surface:get_width() * 0.92 + 10,
			height = (surface:get_height() - 50) * 0.92 + 10,
		})
		sub_surface:clear({r=65, g=70, b=72, a=255})

		self.sub_view:render(SubSurface(sub_surface, {
			x = 5,
			y = 5,
			width = sub_surface:get_width() - 10,
			height = sub_surface:get_height() - 10,
		}))
	end

	self.top_bar:render(SubSurface(surface, {
		x = 0,
		y = 0,
		width = surface:get_width(),
		height = 60,
	}))

	self:dirty(false)
end

-- Destroys all images and views when leaving cityview
function CityView:destroy()
	view.View.destroy(self)
	for k,v in pairs(self.images) do
		self.images[k]:destroy()
	end

	self.top_bar:destroy()
end

function CityView:load_view(button)
	if button == "back" then
		self:exit_city_view()
	end
end

return CityView
