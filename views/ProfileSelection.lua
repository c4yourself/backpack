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

--local ProfileSelection = {}

function ProfileSelection:__init()
	View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

	self.color = Color()

	--local profile_list =  {"MaxiStormarknad","Bingoberra","Eivar","Skumtomte_90", "D4ngerBoi390KickflippingRainbow", "Wedge", "Biggles"} -- put contents of the scroll frame here, for example item names
	self.profile_manager = ProfileManager()
	self.profile_list = self.profile_manager:list()
	self.profile_index = 0 --Zero indexing over profile_list
	self.menu_index = 1
	self.isLeftMenu = true

	--creates some colors
	self.button_color = {r=250, g=105, b=0} --color.from_html("#fa6900ff")--{r=0, g=128, b=225}
	self.button_color_select = {r=250, g=169, b=0}--color.from_html("#faa900ff") --{r=255,g=182,b=193}
	self.text_color = {r=255, g=255, b=255}--color.from_html("#ffffff52")--{r=0, g=0, b=0}
	self.menu_text_color = {r=255, g=255, b=255}
	self.background_color = {r=30, g=35, b=35}


	self.listening_initiated = false

	-- Common fonts
	self.font_header = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.font_button = Font("data/fonts/DroidSans.ttf", 30, Color(255, 255, 255, 255))

	-- Listeners and callbacks
	self:listen_to(
		event.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

function ProfileSelection:get_profile()
	return self.profile_list[self.profile_index+1].name
end

function ProfileSelection:get_email()
	return self.profile_list[self.profile_index+1].email_address
end

function ProfileSelection:get_city()
	return self.profile_list[self.profile_index+1]:get_city().name
end

function ProfileSelection:setLeftMenu(bool)
	self.isLeftMenu = bool
end

function ProfileSelection:callFetchProfile()

	login_view = LoginView(event.remote_control, self)
	view.view_manager:set_view(login_view)

end

function ProfileSelection:callContinueGame()
	cur_prof = self.profile_list[self.profile_index+1]
	result = self.profile_manager:check_login(cur_prof)

	if result["error"] then
		login_view = LoginView(event.remote_control,self)
		view.view_manager:set_view(login_view)
	else
		city_view = CityView(cur_prof, event.remote_control)
		view.view_manager:set_view(city_view)
	end
end

function ProfileSelection:callCreateProfile()
	create_profile = CreateProfileView(event.remote_control)
	view.view_manager:set_view(create_profile)
end

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
	elseif key == "back" then
		--TODO find a way to create the correct city view
		self:trigger("exit")
	end
	self:dirty()
end

function ProfileSelection.load_view(button)
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

function ProfileSelection:pickColor(buttonIndex)
	if buttonIndex == -1 then
		return self.button_color_select
	elseif (buttonIndex == self.menu_index and self.isLeftMenu == false) then
		return self.button_color_select
	else
		return self.button_color
	end
end

-- This functions renders the menu view
function ProfileSelection:render(surface)
	-- Resets the surface and draws the background
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

		if (200-self.profile_index*diff_y+diff_y*counter)>0 then
			self.font_button:draw(surface, {x=120,y=(200-self.profile_index*diff_y+diff_y*counter)}, self.profile_list[key].name)
		end

		buttons[counter]= text_button
		counter=counter+1
 	end

	--TitleBar
	local title_bar = SubSurface(surface,{width=600, height=100, x=0, y=0})
	title_bar:clear({r=250, g=105, b=0})
	self.font_header:draw(surface, {x=50,y=20}, "Select Profile:")

	-- Currently selected profile information
	self.font_header:draw(surface, {x=700,y=40}, tostring(self:get_profile()))
	self.font_header:draw(surface, {x=700,y=80}, tostring(self:get_email()))
	self.font_header:draw(surface, {x=700,y=120}, tostring(self:get_city()))

	-- Implements Button 1. Numerical
	button_height_diff = 120
	button_start_height = 250

	--Draws button: Fetch Profile
	surface:fill(self:pickColor(1), {width=500, height=100, x=700, y=button_start_height+button_height_diff*0})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*0}, "Fetch Profile")

	--Draws button: Continue Game
	surface:fill(self:pickColor(2), {width=500, height=100, x=700, y=button_start_height+button_height_diff*1})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*1}, "Continue Game")

	--Draws button: Create New Profile
	surface:fill(self:pickColor(3), {width=500, height=100, x=700, y=button_start_height+button_height_diff*2})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*2}, "Create New Profile")

	--Draws button: Quit
	surface:fill(self:pickColor(4), {width=500, height=100, x=700, y=button_start_height+button_height_diff*3})
	self.font_button:draw(surface, {x=700+50,y=35+button_start_height+button_height_diff*3}, "Quit")

	-- Instance remote control and mapps it to the buttons
	--event.remote_control:on("button_release", ProfileSelection.load_view)
	self:dirty(false)
end

return ProfileSelection
