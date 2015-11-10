local utils = require("lib.utils")
local event = require("lib.event")
local subsurface = require("lib.view.Subsurface")
local view = require("lib.view")

local profile_selection = {}

local profile_list = {"MaxiStormarknad","Bingoberra","Eivar","Skumtomte_90", "D4ngerBoi390KickflippingRainbow"}

function profile_selection.load_view(button)
	if button == "1" then
	--	local numerical_quiz_view = NumericalQuizView()
	--	view.view_manager:set_view(numerical_quiz_view)
		gfx.update()
	elseif button == "2" then
	--	multiplechoice_quiz.render(screen)
		gfx.update()
	elseif button == "3" then
		print("Shut down program")
		sys.stop()
  end
end

local list =  {"MaxiStormarknad","Bingoberra","Eivar","Skumtomte_90", "D4ngerBoi390KickflippingRainbow"} -- put contents of the scroll frame here, for example item names
local buttons = {}

-- This functions renders the menu view
function profile_selection.render(surface)

	-- Resets the surface and draws the background
	local background_color = {r=124, g=130, b=255}
	surface:clear(background_color)
	--surface:copyfrom(gfx.loadpng(utils.absolute_path("data/images/paris_old.png")))

	--creates some colors
	local button_color = {r=0, g=128, b=225}
	local button_color_select = {r=255,g=182,b=193}
	local text_color = {r=0, g=0, b=0}
	local score_text_color = {r=255, g=255, b=255}

  for key,value in pairs(profile_list) do --foreach Profile
    myTable[key] = "foobar"
  end

  local scrollFrame = CreateFrame("ScrollFrame", "MyFirstNotReallyScrollFrame", UIParent, "FauxScrollFrameTemplate")
  scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
  	FauxScrollFrame_OnVerticalScroll(self, offset, BUTTON_HEIGHT, update)
  end)

  for i = 1, NUM_BUTTONS do
  	--local button = CreateFrame("Button", nil, scrollFrame:GetParent())
    local text_button = sys.new_freetype(text_color, 30, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
  	if i == 1 then
  		button:SetPoint("TOP", scrollFrame)
  	else
  		button:SetPoint("TOP", buttons[i - 1], "BOTTOM")
  	end
  	button:SetSize(96, BUTTON_HEIGHT)
  	buttons[i] = button
  end

	-- This makes a freetype to write with
	local text_button1 = sys.new_freetype(text_color, 30, {x=200,y=80}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button2 = sys.new_freetype(text_color, 30, {x=200,y=280}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local text_button3 = sys.new_freetype(text_color, 30, {x=200,y=480}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	--local score = sys.new_freetype(score_text_color, 40, {x=1010,y=170}, utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Shows the score
	--score:draw_over_surface(surface, "Score: " .. "125")

	-- Implements Button 1. Numerical

	surface:fill(button_color_select, {width=500, height=100, x=100, y=50})
	text_button1:draw_over_surface(surface, "1. Bake bagels")

	-- Implements Button 2. Multiple choice question
	surface:fill(button_color, {width=500, height=100, x=100, y=250})
	text_button2:draw_over_surface(surface, "2. ????")

	-- Implements the exit button
	surface:fill(button_color, {width=500, height=100, x=100, y=450})
	text_button3:draw_over_surface(surface, "3. PROFIT")

	-- Testing Subsurface
	local sub_surface1 = subsurface(surface,{width=100, height=100, x=0, y=0})
	sub_surface1:clear({r=255, g=255, b=255, a=255})

	-- Instance remote control and mapps it to the buttons
	--event.remote_control:on("button_release", profile_selection.load_view)
end

return profile_selection
