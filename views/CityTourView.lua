local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local View = require("lib.view.View")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local SubSurface = require("lib.view.SubSurface")
local button= require("lib.components.Button")
local button_grid=require("lib.components.ButtonGrid")
local CityTourView = class("CityTourView", View)
local attractions  = require("lib.attractions")
local PopUpView = require("views.PopUpView")
local Quiz = require("lib.quiz.Quiz")

function CityTourView:__init(remote_control, surface, profile)
	View.__init(self)
	self.buttonGrid = button_grid(remote_control)
	self.city = profile:get_city()
	self.profile = profile
	self.city_tour_quiz = Quiz()

	local width = screen:get_width()*0.9
	local height = (screen:get_height()-50)*0.9

	--To keep track of which attraction to display. Increments every time a user answer a question
	attractionpoint = 1

	-- math.randomseed(os.time())
	-- local order_table = {{1,2,3,4},{1,2,4,3},{1,3,2,4},{1,3,4,2},{1,4,2,3},{1,4,3,2},{2,1,3,4},{2,1,4,3},{2,3,1,4},{2,3,4,1},{2,4,1,3},{2,4,3,1},
	-- 											{3,1,2,4},{3,1,4,2},{3,2,1,4},{3,2,4,1},{3,4,1,2},{3,4,2,1},{4,1,2,3},{4,1,3,2},{4,2,1,3},{4,2,3,1},{4,3,1,2},{4,3,2,1}}
	-- local random_order = math.random(table.getn(order_table))
	-- attractionpoint = order_table[random_order][#order_table[random_order]]


	-- Create some colors
	--border_color = Color(0, 0, 0, 255)

	-- Create the fonts
	city_tour_head_font = Font("data/fonts/DroidSans.ttf", 48, Color(0, 0, 0, 255))
	city_tour_attraction_font = Font("data/fonts/DroidSans.ttf", 25, Color(0, 0, 0, 255))
	city_tour_text =  Font("data/fonts/DroidSans.ttf", 20, Color(0, 0, 0, 255))
	city_tour_question = Font("data/fonts/DroidSans.ttf", 25, Color(0, 0, 0, 255))
	--Create button colors
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local button_text_color = Color(0, 0, 0, 255)

	-- Create the tour images
	self.tour_attraction_images = {}

	for k,v in pairs(attractions.attraction[self.city.code]) do
		table.insert(self.tour_attraction_images, gfx.loadpng(attractions.attraction[self.city.code][k].pic_url))
	end


	-- = {gfx.loadpng(attractions.attraction[self.city.code][1].pic_url),
	-- 															gfx.loadpng(attractions.attraction[self.city.code][2].pic_url]),
	-- 															gfx.loadpng(attractions.attraction[self.city.code][3])
	-- Create the tour image
--	self.tour_attraction_image = gfx.loadpng(attractions.attraction.paris[1].pic_url)

	-- Create answer buttons
	local button_1 = button(button_color, color_selected, color_disabled,true, true, "Correct")
	local button_2 = button(button_color, color_selected, color_disabled,true, false, "False")
	local button_3 = button(button_color, color_selected, color_disabled,true, false, "False")
	local button_4 = button(button_color, color_selected, color_disabled,true, false, "False")

	-- Create text on buttons
	-- X and y values are not used!
	self.city_tour_quiz:generate_citytour_quiz(self.profile:get_current_city(), tostring(attractionpoint))
	button_1:set_textdata(self.city_tour_quiz.questions[1].Choices[1], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_2:set_textdata(self.city_tour_quiz.questions[1].Choices[2], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_3:set_textdata(self.city_tour_quiz.questions[1].Choices[3], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_4:set_textdata(self.city_tour_quiz.questions[1].Choices[4], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))

	local text_height = 75+25*table.getn(attractions.attraction[self.city.code][attractionpoint].text)
	local indent = 100
	-- Create buttons positions and size
	local button_size = {width=9/36*width+5, height=3*(height-text_height)/13}
	local position_1 = {x = width / 3 + indent, y = 5/4*button_size.height+text_height}
	local position_2 = {x = width / 3 + 5/4*indent + button_size.width, y = 5/4*button_size.height+text_height}
	local position_3 = {x = width / 3 + indent, y = 5/2*button_size.height+text_height}
	local position_4 = {x = width / 3 + 5/4* indent + button_size.width, y = 5/2*button_size.height+text_height}

	self.buttonGrid:add_button(position_1, button_size, button_1)
	self.buttonGrid:add_button(position_2, button_size, button_2)
	self.buttonGrid:add_button(position_3, button_size, button_3)
	self.buttonGrid:add_button(position_4, button_size, button_4)

	local callback = utils.partial(self.load_view, self)
	self:listen_to(
	event.remote_control,
	"button_release",
	callback
	)

	local button_callback = function()
		self.buttonGrid:render(surface)
		gfx.update()
	end

-- When an answer is pressed
	local button_click = function(button)
		attractionpoint = attractionpoint + 1
		local type = "message"
		local message = {}
		if self.city_tour_quiz.questions[1].Choices[self.city_tour_quiz.questions[1].correct_answers[1]] == button.text then
			table.insert(message, "Correct answer")
		else
			table.insert(message, "Wrong answer")
		end

		local subsurface = SubSurface(screen,{width=screen:get_width()*0.5, height=(screen:get_height()-50)*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25+50})
    local popup_view = PopUpView(remote_control,subsurface, type, message)
    self:add_view(popup_view)
    self.buttonGrid:blur()

    local button_click_func = function(button)
      if button == "ok" then
      	popup_view:destroy()
      	self.buttonGrid:focus()
				if table.getn(attractions.attraction[self.city.code]) == attractionpoint then

					self:trigger("exit_view")
				else
					self.city_tour_quiz.questions[1] = nil
					self.city_tour_quiz:generate_citytour_quiz(self.profile:get_current_city(), tostring(attractionpoint))
					button_1:set_textdata(self.city_tour_quiz.questions[1].Choices[1], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
					button_2:set_textdata(self.city_tour_quiz.questions[1].Choices[2], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
					button_3:set_textdata(self.city_tour_quiz.questions[1].Choices[3], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
					button_4:set_textdata(self.city_tour_quiz.questions[1].Choices[4], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
					self:render(surface)
					gfx.update()
				end
    	end
    end

    self:listen_to_once(popup_view, "button_click", button_click_func)
    popup_view:render(subsurface)
    gfx.update()





	end

	self:listen_to(
		self.buttonGrid,
		"dirty",
		button_callback
	)
	self:listen_to(
		self.buttonGrid,
		"button_click",
		button_click
	)

end


function CityTourView:render(surface)

	surface:fill({r=255, g=255, b=255, a=255})

	local height = surface:get_height()
	local width = surface:get_width()
	local text_indent = 100 -- Indents text area

	-- Create the picture
	surface:copyfrom(self.tour_attraction_images[attractionpoint] ,nil ,{ x = height/6, y = height/6, width = height*0.54*3/5, height = height*3/5})

	-- Draw the fonts
	city_tour_head_font:draw(surface, {x = height/6-10, y = 20}, "City Tour")
	city_tour_attraction_font:draw(surface, {x = 0, y = height*23/30+5, width = width/3, height = 30}, attractions.attraction[self.city.code][attractionpoint].name, "center")

	-- Draw tour text square x-axis
	surface:fill({0,0,0,255}, {width = 2/3*width-150, height = 2, x = width/3+95, y =70})
	surface:fill({0,0,0,255}, {width = 2/3*width-150, height = 2, x = width/3+95, y =75+25*table.getn(attractions.attraction[self.city.code][attractionpoint].text)})

	--Write all the tour text
	for i, text in ipairs(attractions.attraction[self.city.code][attractionpoint].text) do
		local text_width = width*2/3-2*text_indent
		city_tour_text:draw(surface, {x = width/3+text_indent, y = 50+25*i, width = text_width, height = 25}, text, nil, nil)
	end

	-- Tour question
	local text_height = 75 + 25*table.getn(attractions.attraction[self.city.code][attractionpoint].text)
	city_tour_question:draw(surface, {x = width/3, y = text_height, width = width*2/3, height = self.buttonGrid.button_list[1].y - text_height}, self.city_tour_quiz.questions[1].question, "center", "middle")


	--Render buttons
	self.buttonGrid:render(surface)
	self:dirty(false)
end

function CityTourView:destroy()
	view.View.destroy(self)

	for k,v in pairs(self.tour_attraction_images) do
		self.tour_attraction_images[k]:destroy()
		end
end

function CityTourView:load_view(button)

	if button == "back" then

		local type = "confirmation"
    local message =  {"Are you sure you want to exit the City Tour?"}


    local subsurface = SubSurface(screen,{width=screen:get_width()*0.5, height=(screen:get_height()-50)*0.5, x=screen:get_width()*0.25, y=screen:get_height()*0.25+50})
    local popup_view = PopUpView(remote_control,subsurface, type, message)
    self:add_view(popup_view)

    self.buttonGrid:blur()

    local button_click_func = function(button)
      if button == "ok" then
      self:trigger("exit_view")
      else
      popup_view:destroy()
      self.buttonGrid:focus()
      self:dirty(true)
      gfx.update()
    end

    end

    self:listen_to_once(popup_view, "button_click", button_click_func)
    popup_view:render(subsurface)
    gfx.update()
			--Stop listening to everything
			-- TODO
			-- Start listening to the exit
	end
end




return CityTourView
