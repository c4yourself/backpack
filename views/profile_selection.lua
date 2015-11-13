local class = require("lib.classy")
local utils = require("lib.utils")
local event = require("lib.event")
local SubSurface = require("lib.view.SubSurface")
local view = require("lib.view")
local View = require("lib.view.View")
local Color = require("lib.draw.Color")
local profile_selection = class("profile_selection", View)
--local profile_selection = {}

local color = Color()

local profile_list =  {"MaxiStormarknad","Bingoberra","Eivar","Skumtomte_90", "D4ngerBoi390KickflippingRainbow", "Wedge", "Biggles"} -- put contents of the scroll frame here, for example item names
local profile_index = 0 --Zero indexing over profile_list
local menu_index = 1
local isLeftMenu = true

--creates some colors
local button_color = {r=250, g=105, b=0} --color.from_html("#fa6900ff")--{r=0, g=128, b=225}
local button_color_select = {r=250, g=169, b=0}--color.from_html("#faa900ff") --{r=255,g=182,b=193}
local text_color = {r=255, g=255, b=255}--color.from_html("#ffffff52")--{r=0, g=0, b=0}
local menu_text_color = {r=255, g=255, b=255}

function profile_selection:__init()
	View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

	self.listening_initiated = false

	-- Graphics
	self.font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Listeners and callbacks
	self:listen_to(
		event.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

function profile_selection:get_profile()
	return profile_list[profile_index+1]
end

local function setLeftMenu(bool)
	isLeftMenu = bool
end

local function callFetchProfile()
	---TODO: Fetch profile from global server
end

local function callContinueGame()
	---TODO: Resume from the players current city. Call view and load profile.
end

local function callCreateProfile()
	---TODO: Starts the create profile view.
end

local function okBtnPress()
	if isLeftMenu then
		isLeftMenu = false
		menu_index = 2
	else
		if menu_index == 1 then
			callFetchProfile()
		elseif menu_index == 2 then
			callContinueGame()
		elseif menu_index == 3 then
			callCreateProfile()
		elseif menu_index == 4 then
			sys.stop()
		end
	end
end

local function downBtnPress()
	if isLeftMenu then
		if profile_index + 1 > #profile_list-1 then
			profile_index = 0
		else
			profile_index = profile_index + 1
		end
	else
		if menu_index + 1 > 4 then
			menu_index = 1
		else
			menu_index = menu_index + 1
		end
	end
end

local function upBtnPress()
	if isLeftMenu then
		if profile_index - 1 < 0 then
			profile_index = #profile_list-1
		else
			profile_index = profile_index - 1
		end
	else
		if menu_index - 1 < 1 then
			menu_index = 4
		else
			menu_index = menu_index - 1
		end
	end
end

function profile_selection:press(key)
	if key == "right" then
		setLeftMenu(false)
	elseif key == "left" then
		setLeftMenu(true)
	elseif key == "ok" then
		okBtnPress()
	elseif key == "down" then
		downBtnPress()
	elseif key == "up" then
		upBtnPress()
	elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
	end
	self:trigger("dirty")
end

function profile_selection.load_view(button)
	if button == "1" then
	--	local numerical_quiz_view = NumericalQuizView()
	--	view.view_manager:set_view(numerical_quiz_view)
		gfx.update()
	elseif button == "2" then
	--	multiplechoice_quiz.render(screen)
		gfx.update()
	elseif button == "3" then
		sys.stop()
  end
end

local buttons = {}

local function pickColor(buttonIndex)
	if buttonIndex == -1 then
		return button_color_select
	elseif (buttonIndex == menu_index and isLeftMenu == false) then
		return button_color_select
	else
		return button_color
	end
end

-- This functions renders the menu view
function profile_selection.render(surface)
	-- Resets the surface and draws the background
	local background_color = {r=30, g=35, b=35}
	surface:clear(background_color)
	--surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris_old.png")))

	local counter = 1
	local diff_y = 80--200

	local roulette_background = SubSurface(surface,{width=600, height=surface:get_height(), x=0, y=0})
	roulette_background:clear({r=65, g=70, b=72})

  for key,value in pairs(profile_list) do --foreach Profile

		local text_button = sys.new_freetype(text_color, 30, {x=120,y=(200-profile_index*diff_y+diff_y*counter)}, utils.absolute_path("data/fonts/DroidSans.ttf"))
		local leftMenuCurrentValue = -2
		if counter == 1 then
			if isLeftMenu then
				leftMenuCurrentValue = -1
			end
			surface:fill(pickColor(leftMenuCurrentValue), {width=500, height=100, x=100, y=(250)})
		end
		text_button:draw_over_surface(surface, profile_list[key])

		buttons[counter]= text_button
		counter=counter+1
  end

	--TitleBar
	local title_bar = SubSurface(surface,{width=600, height=100, x=0, y=0})
	title_bar:clear({r=250, g=105, b=0})

	local select_profile_label = sys.new_freetype(menu_text_color, 40, {x=50,y=20}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	select_profile_label:draw_over_surface(surface, "Select Profile:")


	local spoc = sys.new_freetype(menu_text_color, 40, {x=700,y=40}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	spoc:draw_over_surface(surface, tostring(profile_selection:get_profile()))
	-- Implements Button 1. Numerical

	local button_height_diff = 120
	local button_start_height = 250

	--Draws button: Fetch Profile
	local log_in_button = sys.new_freetype(menu_text_color, 30, {x=700+50,y=35+button_start_height+button_height_diff*0}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	surface:fill(pickColor(1), {width=500, height=100, x=700, y=button_start_height+button_height_diff*0})
	log_in_button:draw_over_surface(surface, "Fetch Profile")

	--Draws button: Continue Game
	local continue_game_button = sys.new_freetype(menu_text_color, 30, {x=700+50,y=35+button_start_height+button_height_diff*1}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	surface:fill(pickColor(2), {width=500, height=100, x=700, y=button_start_height+button_height_diff*1})
	continue_game_button:draw_over_surface(surface, "Continue Game")

	--Draws button: Create New Profile
	local create_profile_button = sys.new_freetype(menu_text_color, 30, {x=700+50,y=35+button_start_height+button_height_diff*2}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	surface:fill(pickColor(3), {width=500, height=100, x=700, y=button_start_height+button_height_diff*2})
	create_profile_button:draw_over_surface(surface, "Create New Profile")

	--Draws button: Quit
	local quit_button = sys.new_freetype(menu_text_color, 30, {x=700+50,y=35+button_start_height+button_height_diff*3}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	surface:fill(pickColor(4), {width=500, height=100, x=700, y=button_start_height+button_height_diff*3})
	quit_button:draw_over_surface(surface, "Quit")

	-- Instance remote control and mapps it to the buttons
	--event.remote_control:on("button_release", profile_selection.load_view)
end

return profile_selection
