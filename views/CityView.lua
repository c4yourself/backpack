--- Base class for CityView
-- A CityView is the input field in a numerical quiz. It responds
-- to numerical input on the remote.
-- @classmod CityView

local Button = require("lib.components.Button")
local ButtonGrid=require("lib.components.ButtonGrid")
local class = require("lib.classy")
local CityTourView = require("views.CityTourView")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local event = require("lib.event")
local logger = require("lib.logger")
local SubSurface = require("lib.view.SubSurface")
local utils = require("lib.utils")
local view = require("lib.view")

local CityView = class("CityView", view.View)

--- Constructor for CityView
-- @param event_listener Remote control to listen to
function CityView:__init(profile, remote_control)
	view.View.__init(self)

	self.background_path = ""
	--Instance of the  current profile, can be used to get name, sex etc
	self.profile = profile
	self.button_grid = ButtonGrid(remote_control or event.remote_control)

	local text_color = Color(111, 189, 88, 255)
	-- Create some button colors
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255) --have not been used yet

	local city_view_selected_color = Color(0, 0, 0, 100)
	local city_view_color = Color(0, 0, 0, 0)

	-- Create some fonts to write with
	city_view_small_font = Font("data/fonts/DroidSans.ttf", 20, Color(255, 255, 255, 255))
	city_view_large_font = Font("data/fonts/DroidSans.ttf", 25, Color(255, 255, 255, 255))

	-- Creates local variables for height and width
	local height = screen:get_height()
	local width = screen:get_width()

	-- Add buttons
	local button_1 = Button(button_color, color_selected, color_disabled,true,true,"views.NumericalQuizView")
	local button_2 = Button(button_color, color_selected, color_disabled,true,false, "views.MultipleChoiceView")
	local button_3 = Button(button_color, color_selected, color_disabled,true,false, "views.MemoryView")
	local button_4 = Button(button_color, color_selected, color_disabled,true,false)
	local button_5 = Button(button_color, color_selected, color_disabled,true,false, "views.Store")
	local button_6 = Button(button_color, color_selected, color_disabled,true,false)
	local button_7 = Button(button_color, color_selected, color_disabled,true,false, "views.TravelView")
	local button_8 = Button(button_color, color_selected, color_disabled,true,false)
	local city_tour_button = Button(city_view_color, city_view_selected_color, color_disabled, true, false, "views.CityTourView")

	city_tour_button:add_icon(
		"data/images/"..self.profile.city .. "Icon.png",
		"data/images/"..self.profile.city.."IconSelected.png",
		0, 0, width * 2 / 3, height * 0.85)

	--button_1:set_textdata("Numerical quiz",text_color,{x=100,y=300},16,utils.absolute_path("data/fonts/DroidSans.ttf"))
	--button_2:set_textdata("Multiple choice question",text_color,{x=200,y=300},16,utils.absolute_path("data/fonts/DroidSans.ttf"))
	-- button_1:set_textdata("Numerical quiz",text_color,{x=100,y=300},16,utils.absolute_path("data/fonts/DroidSans.ttf"))
	-- button_2:set_textdata("Multiple choice question",text_color,{x=200,y=300},16,utils.absolute_path("data/fonts/DroidSans.ttf"))
	-- button_3:set_textdata("Memory",text_color,{x=100,y=400},16,utils.absolute_path("data/fonts/DroidSans.ttf"))

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

	local button_callback = function(button)
		local subsurface = SubSurface(screen,{width=screen:get_width()*0.9, height=(screen:get_height()-50)*0.9, x=screen:get_width()*0.05, y=screen:get_height()*0.05+50})
		local make_instance = self.button_grid:display_next_view(button.transfer_path)
		local one_instance = make_instance(remote_control, subsurface, self.profile)
		self.button_grid:stop_listening(self.button_grid.event_listener,"button_press",callback)
		one_instance:render(subsurface)

		local exit_view = function()
				self.button_grid:focus()
				one_instance:destroy()
				self:dirty(true)
		end

		self:listen_to_once(one_instance,"exit_view", exit_view)
		-- local CT = CityTourView(remote_control, city_tour_view)
		-- self.button_grid:stop_listening(self.buttonGrid.event_listener,
		--  													"button_press",
		-- 													callback)
		-- CT:render(city_tour_view)
		gfx.update()
	end

	local button_render = function()
		self:render(screen)
		gfx.update()
	end

	self:listen_to(
		self.button_grid,
		"dirty",
		button_render
	)
	self:listen_to(
		self.button_grid,
		"button_click",
		button_callback
	)

	-- Preload images for increased performance
	self.images = {
		paris = gfx.loadpng("data/images/"..self.profile.city..".png"),
		coin = gfx.loadpng("data/images/coinIcon.png"),

		paris_selected = gfx.loadpng("data/images/"..self.profile.city.."IconSelected.png"),
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
	self.images.coin:premultiply()
	self.images.paris_selected:premultiply()
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

	-- Instance remote control and mapps it to the buttons
	self.callback = utils.partial(self.load_view, self)
	self:listen_to(
		event.remote_control,
		"button_release",
		self.callback
	)
end

function CityView:render(surface)
	-- Creates local variables for height and width
	local height = surface:get_height()
	local width = surface:get_width()

	local city = self.profile:get_city()

	-- Resets the surface and draws the background
	local background_color = {r = 0, g = 0, b = 0}

	surface:clear(background_color)

	surface:copyfrom(self.images.paris, nil, nil, false)

	--creates some colors
	local text_color = Color(0, 0, 0,255)
	local score_text_color = Color(255, 255, 255, 255)
	local menu_bar_color = Color(0, 0, 0, 225)
	local status_bar_color = Color(0, 0, 0, 255)
	local status_text_color = Color(255, 255, 255, 255)
	local experience_bar_color = Color(100, 100, 100, 255)

	-- Shows menu bar
	surface:fill(menu_bar_color, {width=width/3, height=height-50, x=0, y=50})
	city_view_large_font:draw(surface, {x=width/6-65, y=60}, "Mini Games")
	city_view_large_font:draw(surface, {x=width/6-45, y=(height-50)/2+60}, "Options")

	-- Implement status bar
	surface:fill(status_bar_color, {width=width, height=50, x=0, y=0})
	surface:fill(score_text_color, {width=150, height=30, x=285,y=10})
	if self.profile.experience / 500 ~= 1 then
		surface:fill(experience_bar_color, {width=math.ceil(148*(1-self.profile.experience/500)), height=28, x=434-148*(1-self.profile.experience/500), y=11})
	end

	-- Add info to statusbar
	city_view_large_font:draw(surface,  {x=10, y=10}, self.profile.name) -- Profile name
	city_view_small_font:draw(surface, {x=200, y=15}, "Level: 3") -- Profile level
	city_view_small_font:draw(surface, {x=440, y=15}, tostring(self.profile.experience .. "/500")) -- Profile experience
	city_view_small_font:draw(surface, {x=width-100, y=15}, city.country:format_balance(
		city.country:universal_to_local_currency(self.profile.balance))) -- Profile cash
	city_view_large_font:draw(surface, {x=width/2, y=15}, self.profile:get_city().name, center) -- City name

	surface:copyfrom(self.images.coin, nil, {x = width-145, y = 10, width = 30, height = 30}) -- Coin

 	-- using the button grid to render all buttons and texts
	self.button_grid:render(surface)

	--surface:copyfrom(self.images.paris_selected, nil, {x = width/3, y = 0, width=width*2/3, height=height})
	surface:copyfrom(self.images.multiple_choice_icon, nil, {x = self.button_grid.button_list[1].x, y = self.button_grid.button_list[1].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})
	surface:copyfrom(self.images.math_icon, nil, {x = self.button_grid.button_list[2].x, y = self.button_grid.button_list[2].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})
	surface:copyfrom(self.images.memory_icon, nil, {x = self.button_grid.button_list[3].x, y = self.button_grid.button_list[3].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})
	surface:copyfrom(self.images.four_in_a_row_icon, nil, {x = self.button_grid.button_list[4].x, y = self.button_grid.button_list[4].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})
	surface:copyfrom(self.images.store_icon, nil, {x = self.button_grid.button_list[5].x, y = self.button_grid.button_list[5].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})
	surface:copyfrom(self.images.user_icon, nil, {x = self.button_grid.button_list[6].x, y = self.button_grid.button_list[6].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})
	surface:copyfrom(self.images.flight_icon, nil, {x = self.button_grid.button_list[7].x, y = self.button_grid.button_list[7].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})
	surface:copyfrom(self.images.exit_icon, nil, {x = self.button_grid.button_list[8].x, y = self.button_grid.button_list[8].y, width = self.button_grid.button_list[1].width, height = self.button_grid.button_list[1].height})

	self:dirty(false)
end

-- Destroys all images and views when leaving cityview
function CityView:destroy()
	view.View.destroy(self)
	for k,v in pairs(self.images) do
		self.images[k]:destroy()
	end
end

function CityView:load_view(button)
	if button == "1" then
		--Instanciate a numerical quiz
		local numerical_quiz_view = NumericalQuizView()
		--Stop listening to everything
		self:stop_listening(event.remote_control)
		self.button_grid:stop_listening() -- TODO Use button_grid:blur instead
		-- Start listening to the exit event, which is called when the user
		-- exits a quiz
		local numerical_exit_callback = function()
			utils.partial(view.view_manager.set_view, view.view_manager)(self)
			-- TODO Focus buttongrid
			gfx.update()
		end
		self:listen_to(
			numerical_quiz_view,
			"exit",
			numerical_exit_callback
		)
		local numerical_dirty_callback = function()
			numerical_quiz_view:render(screen)
		end
		self:listen_to(
			numerical_quiz_view,
			"dirty",
			numerical_dirty_callback
		)

		--Update the view
		numerical_quiz_view:render(screen)
		-- TODO This should be done with a subsurface in the final version
		gfx.update()
	elseif button == "2" then
		local mult_quiz_view = MultipleChoiceView()
		--Stop listening to everything
		self:stop_listening(event.remote_control)
		self.button_grid:stop_listening() -- TODO Use button_grid:blur instead
		-- Start listening to the exit event, which is called when the user
		-- exits a quiz
		local mult_choice_exit_callback = function()
			utils.partial(view.view_manager.set_view, view.view_manager)(self)
			gfx.update()
		end
		self:listen_to(
			mult_quiz_view,
			"exit",
			mult_choice_exit_callback
		)

		-- Make the city view listen for the "dirty" event
		local mult_choice_dirty_callback = function()
			mult_quiz_view:render(screen)
		end
		self:listen_to(
			mult_quiz_view,
			"dirty",
			mult_choice_dirty_callback
		)
		--Update the view
		mult_quiz_view:render(screen)
		-- TODO ^This should be done by a subsurface in the final version
		gfx.update()
	elseif button == "3" then
		sys.stop()
	elseif button == "5" then
		local city_tour_view = SubSurface(screen,{width=screen:get_width()*0.9, height=(screen:get_height()-50)*0.9, x=screen:get_width()*0.05, y=screen:get_height()*0.05+50})
		local CT = CityTourView(remote_control, city_tour_view)
		self.button_grid:blur()

		CT:render(city_tour_view)
		gfx.update()

		local exit_view = function()

				self.button_grid:focus()
				CT:destroy()
				self:dirty(true)
		end

		self:listen_to_once(CT,"exit_view", exit_view)
	end
end

return CityView
