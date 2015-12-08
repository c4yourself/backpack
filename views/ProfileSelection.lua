local class = require("lib.classy")
local utils = require("lib.utils")
local event = require("lib.event")
local SubSurface = require("lib.view.SubSurface")
local Font = require("lib.draw.Font")
local view = require("lib.view")
local View = require("lib.view.View")
local Color = require("lib.draw.Color")
local Profile = require("lib.profile.Profile")
local ProfileManager = require("lib.profile.ProfileManager")
local CreateProfileView = require("views.CreateProfileView")
local CityView = require("views.CityView")
local LoginView = require("views.LoginView")
local ProfileSelection = class("ProfileSelection", View)

--- Constructor
-- @param remote_control
function ProfileSelection:__init(remote_control)
	View.__init(self)
	self.remote_control = remote_control
	self.color = Color()

	--local profile_list =  {"MaxiStormarknad","Bingoberra","Eivar","Skumtomte_90", "D4ngerBoi390KickflippingRainbow", "Wedge", "Biggles"} -- put contents of the scroll frame here, for example item names
	self.profile_manager = ProfileManager()
	self.profile_list = self.profile_manager:list()
	self.profile_index = 0 --Zero indexing over profile_list
	self.menu_index = 1
	self.isLeftMenu = true

	--Creates colors
	self.button_color = {r=250, g=105, b=0} --color.from_html("#fa6900ff")--{r=0, g=128, b=225}
	self.button_color_select = {r=250, g=169, b=0}--color.from_html("#faa900ff") --{r=255,g=182,b=193}
	self.text_color = {r=255, g=255, b=255}--color.from_html("#ffffff52")--{r=0, g=0, b=0}
	self.menu_text_color = {r=255, g=255, b=255}
	self.background_color = {r=30, g=35, b=35}


	self.listening_initiated = false

	-- Common fonts
	self.font_header = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.font_button = Font("data/fonts/DroidSans.ttf", 32, Color(255, 255, 255, 255))

	-- Listeners and callbacks
	self:listen_to(
		self.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

--- Returns marked profile's name
-- @param
function ProfileSelection:get_name()
	return self.profile_list[self.profile_index+1].name
end

--- Returns marked profile's email
-- @param
function ProfileSelection:get_email()
	return self.profile_list[self.profile_index+1].email_address
end

--- Returns marked profile's current city
-- @param
function ProfileSelection:get_city()
	return self.profile_list[self.profile_index+1]:get_city().name
end

--- Sets the Profile List (i.e. LeftMenu) active/inactive.
-- @param bool
function ProfileSelection:setLeftMenu(bool)
	self.isLeftMenu = bool
end

--- Calls the Log In View
-- @param
function ProfileSelection:callFetchProfile()
	login_view = LoginView(event.remote_control)
	view.view_manager:set_view(login_view)
end

--- Calls for continuing selected profile's game
---Otherwise, calls for a log in
-- @param
function ProfileSelection:callContinueGame()
	cur_prof = self.profile_list[self.profile_index+1]
	result = self.profile_manager:check_login(cur_prof)

	if result["error"] then
		login_view = LoginView(event.remote_control,self)
		view.view_manager:set_view(login_view)
	else
		cur_prof = result
		city_view = CityView(cur_prof, event.remote_control)
		view.view_manager:set_view(city_view)
	end
end

--- Calls for the Create Profile View
-- @param
function ProfileSelection:callCreateProfile()
	create_profile = CreateProfileView(self.remote_control)
	view.view_manager:set_view(create_profile)
end

--- Runs when the OK from remote control has been pressed.
-- @param
function ProfileSelection:okBtnPress()
	if self.isLeftMenu then
		self.isLeftMenu = false
		self.menu_index = 2
	else
		if self.menu_index == 1 then
			self:callFetchProfile()
		elseif self.menu_index == 2 then
			self:callContinueGame()
		elseif self.menu_index == 3 then
			self:callCreateProfile()
		elseif self.menu_index == 4 then
			sys.stop()
		end
	end
end

--- Runs when the DOWN from remote control has been pressed.
-- @param
function ProfileSelection:downBtnPress()
	if self.isLeftMenu then
		if self.profile_index + 1 > #self.profile_list-1 then
			self.profile_index = 0
		else
			self.profile_index = self.profile_index + 1
		end
	else
		if self.menu_index + 1 > 4 then
			self.menu_index = 1
		else
			self.menu_index = self.menu_index + 1
		end
	end
end

--- Runs when the UP from remote control has been pressed.
-- @param
function ProfileSelection:upBtnPress()
	if self.isLeftMenu then
		if self.profile_index - 1 < 0 then
			self.profile_index = #self.profile_list-1
		else
			self.profile_index = self.profile_index - 1
		end
	else
		if self.menu_index - 1 < 1 then
			self.menu_index = 4
		else
			self.menu_index = self.menu_index - 1
		end
	end
end

--- Runs when the any button on the remote control has been pressed.
-- @param key
function ProfileSelection:press(key)
	if key == "right" then
		self:setLeftMenu(false)
	elseif key == "left" then
		self:setLeftMenu(true)
	elseif key == "ok" then
		self:okBtnPress()
	elseif key == "down" then
		self:downBtnPress()
	elseif key == "up" then
		self:upBtnPress()
	elseif key == "red" or key == "3" then
		sys.stop()
	end
	self:dirty()
end

--- Sets button color corresponding to active menu index.
-- @param buttonIndex
function ProfileSelection:pickColor(buttonIndex)
	if buttonIndex == -1 then
		return self.button_color_select
	elseif (buttonIndex == self.menu_index and self.isLeftMenu == false) then
		return self.button_color_select
	else
		return self.button_color
	end
end

--- Draws the view on the given surface
-- @param surface
function ProfileSelection:render(surface)
	surface:clear(self.background_color)

	local counter = 1
	local diff_y = 80--200

	local roulette_background = SubSurface(surface,{width=600, height=surface:get_height(), x=0, y=0})
	roulette_background:clear({r=65, g=70, b=72})

	for key,value in pairs(self.profile_list) do --foreach Profile
		self.leftMenuCurrentValue = -2
		if counter == 1 then
			if self.isLeftMenu then
				self.leftMenuCurrentValue = -1
			end
			surface:fill(self:pickColor(self.leftMenuCurrentValue), {width=500, height=100, x=100, y=(250)})
		end

		local y_pos = (200-self.profile_index*diff_y+diff_y*counter)
		if y_pos>0 and y_pos<screen:get_height() then
			self.font_button:draw(surface, {x=120,y=y_pos}, self.profile_list[key].name)
		end

		counter=counter+1
 	end

	--TitleBar
	local title_bar = SubSurface(surface,{width=600, height=100, x=0, y=0})
	title_bar:clear({r=250, g=105, b=0})
	self.font_header:draw(surface, {x=50,y=20}, "Select Profile:")

	-- Currently selected profile information
	self.font_header:draw(surface, {x=700,y=40}, tostring(self:get_name()))
	self.font_header:draw(surface, {x=700,y=80}, tostring(self:get_email()))
	self.font_header:draw(surface, {x=700,y=120}, tostring(self:get_city()))

	-- Implements Button 1. Numerical
	button_height_diff = 120
	button_start_height = 250

	--Draws button: Fetch Profile
	surface:fill(self:pickColor(1), {width=500, height=100, x=700, y=button_start_height+button_height_diff*0})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*0}, "Log In")

	--Draws button: Continue Game
	surface:fill(self:pickColor(2), {width=500, height=100, x=700, y=button_start_height+button_height_diff*1})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*1}, "Continue Game")

	--Draws button: Create New Profile
	surface:fill(self:pickColor(3), {width=500, height=100, x=700, y=button_start_height+button_height_diff*2})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*2}, "Create New Profile")

	--Draws button: Quit
	surface:fill(self:pickColor(4), {width=500, height=100, x=700, y=button_start_height+button_height_diff*3})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*3}, "Quit")

	self:dirty(false)
end

return ProfileSelection
