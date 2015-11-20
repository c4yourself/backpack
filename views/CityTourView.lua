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

function CityTourView:__init(remote_control, surface)
	View.__init(self)
	self.buttonGrid = button_grid(remote_control)

	local width = screen:get_width()*0.9
	local height = (screen:get_height()-50)*0.9

	-- Create some colors
	--border_color = Color(0, 0, 0, 255)

	-- Create the fonts
	city_tour_head_font = Font("data/fonts/DroidSans.ttf", 48, Color(0, 0, 0, 255))
	city_tour_attraction_font = Font("data/fonts/DroidSans.ttf", 25, Color(0, 0, 0, 255))
	city_tour_text =  Font("data/fonts/DroidSans.ttf", 20, Color(0, 0, 0, 255))

	--Create button colors
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local button_text_color = Color(0, 0, 0, 255)

--	local color_disabled = color(111, 222, 111, 255) --have not been used yet
	self.attraction = {name = "The Eiffel Tower", pic_url = "data/images/CityTourEiffelTower.png",
										text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
														"company designed and built the tower. It was finished in 1889 and",
														"it is a global cultural icon of France and one of the most recognisable",
														"structures in the world. Around 6.98 million people visited the Eiffel",
														"Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
														"wide. The Eiffel Tower was the tallest man-made structure in the",
														"world for 41 years. Today it is the second-tallest structure in France.",
														" The tower has three levels for visitors, with restaurants on the first",
														"and second. The third level observatory's upper platform is 276 m",
														"above the ground. The climb from ground level to the first level is",
														"over 300 steps."},
										question = "How tall is the Eiffel Tower?",
										answers = {"324 metres", "564 metres", "137 metres", "401 metres"}}

	-- Create answer buttons
	local button_1 = button(button_color, color_selected, color_disabled,true, true)
	local button_2 = button(button_color, color_selected, color_disabled,true, false)
	local button_3 = button(button_color, color_selected, color_disabled,true, false)
	local button_4 = button(button_color, color_selected, color_disabled,true, false)

	-- Create text on buttons
	-- X and y values are not used!
	button_1:set_textdata(self.attraction.answers[1], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_2:set_textdata(self.attraction.answers[2], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_3:set_textdata(self.attraction.answers[3], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))
	button_4:set_textdata(self.attraction.answers[4], button_text_color, {x=200, y=200}, 16, utils.absolute_path("data/fonts/DroidSans.ttf"))

	local text_height = 75+25*table.getn(self.attraction.text)
	local indent = 55
	-- Create buttons positions and size
	local button_size = {width=4*(width-indent)/27, height=4*(height-text_height)/13}
	local position_1 = {x = 2*(width-indent)/3, y = button_size.height/2+text_height}
	local position_2 = {x = 2*(width-indent)/3+button_size.width*5/4, y = button_size.height/2+text_height}
	local position_3 = {x = 2*(width-indent)/3, y = 7*button_size.height/4+text_height}
	local position_4 = {x = 2*(width-indent)/3+button_size.width*5/4, y = 7*button_size.height/4+text_height}

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
	self:listen_to(
		self.buttonGrid,
		"dirty",
		button_callback
	)

end


function CityTourView:render(surface)
	surface:fill({r=255, g=255, b=255, a=255})

	local height = surface:get_height()
	local width = surface:get_width()
	local text_indent = 100 -- Indents text area

	-- Create the picture
	surface:copyfrom(gfx.loadpng(self.attraction.pic_url) ,nil ,{ x = height/6, y = height/6, width = height*0.54*3/5, height = height*3/5})


	-- Draw the fonts
	city_tour_head_font:draw(surface, {x = height/6-10, y = 20}, "City Tour")
	city_tour_attraction_font:draw(surface, {x = height/6, y = height*23/30+5, width = height*0.54*3/5, height = 30}, self.attraction.name, center)

	-- Draw tour text square x-axis
	surface:fill({0,0,0,255}, {width = 2/3*width-150, height = 2, x = width/3+95, y =45})
	surface:fill({0,0,0,255}, {width = 2/3*width-150, height = 2, x = width/3+95, y =75+25*table.getn(self.attraction.text)})

	--Write all the tour text
	for i, text in ipairs(self.attraction.text) do
		local text_width= width*2/3-2*text_indent
		city_tour_text:draw(surface, {x = width/3+text_indent, y = 50+25*i, width = text_width, height = 25}, text, nil, nil)
	end

	-- Tour question
	city_tour_text:draw(surface, {x = width/3+text_indent, y = (height+50+25*table.getn(self.attraction.text))/2, width = 50, height = 50}, self.attraction.question)

	--Render buttons
	self.buttonGrid:render(surface)
	print("var i citytour")
	--self:trigger("exit_view")
end
	function CityTourView:load_view(button)

		if button == "back" then
		self:trigger("exit_view")
			--Stop listening to everything
			-- TODO
			-- Start listening to the exit

		end
	end




return CityTourView
