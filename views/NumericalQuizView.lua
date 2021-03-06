--- Base class for NumericQuizView. View class responsible for rendering the
-- numerical quiz and its child components
-- @classmod NumericQuizView
local NumericalInputComponent = require("components.NumericalInputComponent")
local class = require("lib.classy")
local View = require("lib.view.View")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local Quiz = require("lib.quiz.Quiz")
local NumericQuestion = require("lib.quiz.NumericQuestion")
local SubSurface = require("lib.view.SubSurface")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local NumericalQuizGrid = require("components.NumericalQuizGrid")
local Button = require("components.Button")
local ExperienceCalculation = require("lib.scores.experiencecalculation")
local PopUpView = require("views.PopUpView")


local NumericQuizView = class("NumericQuizView", View)

--- Constructor for NumericQuizView
-- @param remote_control Remote control instance to listen to
-- @param subsurface {@Surface} or {@SubSurface} to draw on
-- @param profile Profile of the current user
function NumericQuizView:__init(remote_control, subsurface, profile)
	View.__init(self)
	self.remote_control = remote_control
	self.surface = subsurface
	self.profile = profile

-- For de-bugging, TODO remove
	self.next_counter = 0
	self.show_answer_counter = 0

-- Flags
	self.answer_flag = false
	self.quiz_flag = false
	self.listening_initiated = false
	self.input_area_defined = false
	self.areas_defined = false
	self.prevent = false -- This flag is used for avoiding bug where render is
						-- called twice upon a submit.
	self._suppress_new_question = false
	--Components
	self.views.grid = NumericalQuizGrid(remote_control)
	--Instanciate a numerical input component and make the quiz listen for changes
	self.views.num_input_comp = NumericalInputComponent()

	--Button data
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255)

	local height = math.ceil(subsurface:get_height())
	local width = math.ceil(subsurface:get_width())
	local button_size = {width = 300, height = 75}

	-- Add exit button
	local button_exit = Button(button_color, color_selected, color_disabled,
								true, false, "views.CityView")
	local exit_position = {x = 75, y = 450}
	button_exit:set_textdata("Back to city", Color(255,255,255,255),
							{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(exit_position,
						button_size,
						button_exit)
	local exit_index = self.views.grid:get_last_index()
	self.views.grid:mark_as_back_button(exit_index)

	-- Add next button
	local button_next = Button(button_color, color_selected, color_disabled,
								true, false, "")
	local next_position = {x = 840 , y = 420}
	button_next:set_textdata("Next question", Color(255,255,255,255),
							{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(next_position,
						{width = 230, height = 75},
						button_next)
	local next_index = self.views.grid:get_last_index()
	self.views.grid:mark_as_next_button(next_index)

	-- Logic
	-- Associate a quiz instance with the View
	self.num_quiz = Quiz()
	self.progress_table = {}
	self:_set_level()
	self.num_quiz:generate_numerical_quiz(self.level, 10, "image_path")

	for i=1, #self.num_quiz.questions do
		self.progress_table[i] = -1
	end
	self.user_answer = ""

	-- Background colors for this view's own subsurfaces
	self.question_area_color = Color( 0, 0, 0, 175)
	self.progress_counter_color = Color(255,99,0,255)
	self.question_area_font = Font("data/fonts/DroidSans.ttf", 26,
									Color(255,255,255,255))
	self.progress_counter_font = Font("data/fonts/DroidSans.ttf", 32,
									Color(255,255,255,255))
	-- Listeners and callbacks
	self:focus()
end

--- Adjusts the quiz difficulty based on the user's experience
function NumericQuizView:_set_level()
	local exp = self.profile:get_experience()
	if exp <= 100 then
		self.level = "BEGINNER"
	elseif exp <=200 then
		self.level = "NOVICE"
	elseif exp <= 300 then
		self.level = "ADVANCED"
	elseif exp >300 then
		self.level = "EXPERT"
	end
end

--- Responds to a 'key' press when the View is active
-- @param key Key that was pressed by the user
function NumericQuizView:press(key)
 	if key == "back" then
		self:back_to_city()
		self._suppress_new_question = true
		self:dirty(false)
		self:dirty(true)
	end
end

--- Renders a NumericQuizView and all its child views on specified 'surface'
-- @param surface Surface or SubSurface to render upon
function NumericQuizView:render(surface)

	local surface_width = math.ceil(surface:get_width())
	local surface_height = math.ceil(surface:get_height())
	self._pop_up_flag = false

	-- Define input area if it hasn't been done already
	if not self.input_area_defined then
		local input_x = surface_width * 0.465 -50
		local input_y = 420
		local input_height = 75
		local input_width = 225 + 70
		self.input_area = SubSurface(surface, {x = input_x, y = input_y,
									height = input_height,
									width = input_width})
		self.views.grid:add_button({x = input_x, y = input_y},
							{height = input_height , width = input_width},
							self.views.num_input_comp)

		local input_index = self.views.grid:get_last_index()
		self.views.grid:mark_as_input_comp(input_index)
		self.views.grid:select_button(input_index)
		self.views.grid.button_list[input_index].button:focus()
	end




	-- Render the view as long as it isn't clean already
	if self:is_dirty() then
		local color = nil -- Background color for the quiz
		surface:clear(color)
		-- Game info box
		local left_board = SubSurface(surface,{width = 300, height = surface:get_height()-150, x = 75, y = 75})
		left_board:clear(Color(250, 105, 0, 255):to_table())
		left_board:fill({r = 65, g = 70, b = 72, a = 255},
			{x = 5, y = 5, width = 290, height = surface:get_height()-160})
		left_board:fill(Color(250, 105, 0, 255):to_table(),
			{x = 5, y = 75, width = 290, height = 5})
		local text_color = Color(255,255,255,255)
		local text = Font("data/fonts/DroidSans.ttf", 30, text_color)
		text:draw(left_board, {x = 50, y = 20}, "Numerical Quiz" )
		text:draw(left_board, {x = 72, y = 130}, "Question " .. self.num_quiz.current_question)
		-- Define other areas if it hasn't been done already
		if not self.areas_defined then
			-- Game info box
			-- local left_board = SubSurface(surface,{width = 300, height = surface:get_height()-150, x = 75, y = 75})
			-- left_board:clear(Color(250, 105, 0, 255):to_table())
			-- left_board:fill({r = 65, g = 70, b = 72, a = 255},
			-- 	{x = 5, y = 5, width = 290, height = surface:get_height()-160})
			-- left_board:fill(Color(250, 105, 0, 255):to_table(),
			-- 	{x = 5, y = 75, width = 290, height = 5})
			-- local text_color = Color(255,255,255,255)
			-- local text = Font("data/fonts/DroidSans.ttf", 30, text_color)
			-- text:draw(left_board, {x = 50, y = 20}, "Numerical Quiz")
			-- text:draw(left_board, {x = 72, y = 130}, "Question .. self.num_quiz.current_question")
			--Progress counter
			local progress_margin = 26
			self.counter_width = 72
			self.counter_height = 72
			self.x_counter = 50
			self.y_counter = 250
			self.progress_counter_area = SubSurface(surface, {x = self.x_counter,
										y = self.y_counter,
										height = self.counter_height,
										width = self.counter_width})
			--Question area
			local x = surface_width * 0.465 -50
			local y = surface_height * 0.2

			self.question_area_width = surface_width*0.4 +100
			self.question_area_height = 0.3*surface_height

			self.question_area = SubSurface(surface, {x = x, y = y,
				height = self.question_area_height,
				width = self.question_area_width})

			self.areas_defined = true
		end
		-- Question area
		self.question_area:clear(self.question_area_color:to_table())

		--Determine what should be shown in the Question area
		if self.answer_flag then
			-- The user has answered a question
			local current_question = self.num_quiz.current_question
			if self.num_quiz:answer(self.user_answer) then
				output1 = "Correct!"
				output2 = ""
				self.progress_table[current_question] = true
			else
				output1 = "False. You answered " .. tostring(self.user_answer) ..
				 " and"
				 output2 = "the correct answer was "
				 .. tostring(self.num_quiz.questions[current_question].correct_answer) .. "."
				self.progress_table[current_question] = false
			end
			self.question_area_font:draw(self.question_area,
				{x = 0, y = 0, height = self.question_area_height,
				width = self.question_area_width},
				output1, "center", "middle")
			self.question_area_font:draw(self.question_area,
					{x = 0, y = 25, height = self.question_area_height,
					width = self.question_area_width},
					output2, "center", "middle")
			--Highlight the next button and blur the input field
			self.views.grid:select_button(2)
			self.views.grid.button_list[3].button:blur()
			self.answer_flag = false
		elseif self._suppress_new_question then
			self._suppress_new_question = false
			-- Show the current question instead of a new one
			local calculate_text = "Calculate"
			local question_text = self.question_area_text .. " = ?"
			self.question_area_font:draw(self.question_area,
										{x = 0,
										y = self.question_area_height*0.3,
										height = self.question_area_height,
										width = self.question_area_width},
										calculate_text, "center")
			self.question_area_font:draw(self.question_area,
										{x = 0,
										y = self.question_area_height*0.5,
										height = self.question_area_height,
										width = self.question_area_width},
										question_text, "center")
		else

			-- Show a new question if there is one, otherwise show final result
			self.answer_flag = false
			local question = self.num_quiz:get_question()
			self.question_area_text = question
			if question ~= nil then
				local calculate_text = "Calculate"
				local question_text = question .. " = ?"
				self.question_area_font:draw(self.question_area,
											{x = 0,
											y = self.question_area_height*0.3,
											height = self.question_area_height,
											width = self.question_area_width},
											calculate_text, "center")
				self.question_area_font:draw(self.question_area,
											{x = 0,
											y = self.question_area_height*0.5,
											height = self.question_area_height,
											width = self.question_area_width},
											question_text, "center")
			else
				self._pop_up_flag = true
			end
		end

		-- Render the Progress counter

		-- self.progress_counter_area:clear(self.progress_counter_color:to_table())
		-- local current_question = self.num_quiz.current_question
		-- local quiz_length = #self.num_quiz.questions
		-- local current_question = math.min(self.num_quiz.current_question,
		-- 										quiz_length)


		-- self.progress_counter_font:draw(self.progress_counter_area,
		-- 							{x = 0, y = 0, height = self.counter_height,
		-- 							width = self.counter_width},
		-- 							tostring(current_question) .. "/" ..
		-- 							tostring(quiz_length), "center", "middle")

		-- Render the Progress bar
		local bar_component_width = 35
		local bar_component_height = 35
		local progress_bar_margin = 10
		local progress_bar_margin_x = 10
		local progress_bar_margin_y = 24
		local bar_component_x = self.x_counter + self.counter_width -
								bar_component_width + 32
		local bar_component_y = self.y_counter + progress_bar_margin_y +
								self.counter_height - 30
		local quiz_length = #self.progress_table

		-- Create a progress bar and color its boxes

		-- Load boxes for the right and wrong answer
		self.answer_correct = gfx.loadpng("data/images/progress_bar/rsz_11v_checkbox.png")
		self.answer_nil = gfx.loadpng("data/images/progress_bar/rsz_empty_checkbox.png")
		self.answer_false = gfx.loadpng("data/images/progress_bar/rsz_x_checkbox.png")

		for i = 1, quiz_length do
			local progress_bar_component_color = SubSurface(surface,
										{x = bar_component_x+2, y = bar_component_y+2,
										height = bar_component_height-4,
										width = bar_component_width-4})
			local progress_bar_component_pic = SubSurface(surface,
													{x = bar_component_x,
													y = bar_component_y,
													height = bar_component_height,
													width = bar_component_width})
			-- Depending on the user's success: there will be different boxes
			if self.progress_table[i] == true then
				bar_component_color = Color(0,255,0,255)
				progress_bar_component_color:clear(bar_component_color:to_table())
				progress_bar_component_pic:copyfrom(self.answer_correct, nil, nil, true)
			elseif self.progress_table[i] == false then
				bar_component_color = Color(255,0,0,255)
				progress_bar_component_color:clear(bar_component_color:to_table())
				progress_bar_component_pic:copyfrom(self.answer_false, nil, nil, true)
			else
				bar_component_color = Color(1, 1, 1, 50)
				progress_bar_component_color:clear(bar_component_color:to_table())
				progress_bar_component_pic:copyfrom(self.answer_nil, nil, nil, true)
			end

			--bar_component_x = bar_component_x + progress_bar_margin + progress_bar_margin_x
				--				bar_component_width

			bar_component_x = bar_component_x + bar_component_width + progress_bar_margin_x
			if i % 5 == 0 then
					bar_component_x = self.x_counter + self.counter_width -
																	bar_component_width + 32
					bar_component_y = bar_component_y + progress_bar_margin_y +
																	bar_component_height - 17
			end
		end
		self.prevent = false
		self._suppress_new_question = false
	end

	-- In case we haven't started listning to our child views: start doing so
	if not self.listening_initiated then
		local change_callback = utils.partial(self.views.num_input_comp.render,
												self.views.num_input_comp,
												self.input_area)
		-- Triggered when the user changes the input in the input field
		self:listen_to(
			self.views.num_input_comp,
			"change",
			change_callback
		)

		-- Triggered when the user selects a new button/field
		self:listen_to(
			self.views.grid,
			"dirty",
			utils.partial(self.views.grid.render, self.views.grid, surface)
		)

		-- Triggered when the user submits an answer
		self:listen_to(
			self.views.grid,
			"submit",
			utils.partial(self.show_answer, self)
		)

		-- Triggered when the next button is pressed
		self:listen_to(
			self.views.grid,
			"next",
			utils.partial(self.next_question, self)
		)

		-- Triggered when the exit button is pressed
		local cb = function()
			self:back_to_city()
			self._suppress_new_question = true
			self:dirty(true)
			self:dirty(false)
		end
		self:listen_to(
			self.views.grid,
			"back",
			utils.partial(cb, self)
		)

		self.listening_initiated = true
	end

	self.views.grid:render(surface)
	if self._pop_up_flag == true then
		self._suppress_new_question = true
		self:back_to_city()
		local subsurface = SubSurface(screen,{width = screen:get_width()*0.5,
										height = (screen:get_height()-50)*0.5,
										x = screen:get_width()*0.25,
										y = screen:get_height()*0.25+50})
		self.sub_view:render(subsurface)
	elseif self.pop_up_flag_2 then
		local subsurface = SubSurface(screen,{width = screen:get_width()*0.5,
										height = (screen:get_height()-50)*0.5,
										x = screen:get_width()*0.25,
										y = screen:get_height()*0.25+50})
		self._suppress_new_question = true
		self.sub_view:render(subsurface)
	end
	self:dirty(false)
end

--- Set up for showing whether the user answered correctly or not. Only works
-- when the user has entered an answer in the input field. Triggers dirty
function NumericQuizView:show_answer()
	if self.views.num_input_comp:get_text() ~= "" then
		if not self.prevent then
			self.prevent = not self.prevent
			self.answer_flag = true
			self.user_answer = tonumber(self.views.num_input_comp:get_text())
			self.views.num_input_comp:set_text("Enter your answer here")
			self.views.grid:select_button(2)
			self.views.grid.button_list[3].button:blur()
			self:dirty(false)
			self:dirty(true)
		end
	end
end

--- Set up for the next question in the quiz. Triggers dirty
function NumericQuizView:next_question()
	if not self.prevent then
		self.views.grid:select_button(3)
		self.views.grid.button_list[3].button:focus()

		self.answer_flag = false
		self.prevent = false
		self.user_answer = nil
		self.views.num_input_comp:set_text("Enter your answer here")
		self:dirty(false)
		self:dirty(true)
	end
end

--- Method for destroying the numerical quiz view and exiting the quiz
function NumericQuizView:back_to_city()
	--TODO Add pop-up
	local message = ""
	local type = ""
	local current_question = self.num_quiz.current_question
	local quiz_length = #self.num_quiz.questions
	if current_question >= quiz_length then
		local counter  = self.num_quiz.correct_answers
		local experience = ExperienceCalculation.Calculation(counter, "Mathquiz")
		local last_level = (self.profile.experience-(self.profile.experience%100))/100+1
		self.profile:modify_balance(experience)
		self.profile:modify_experience(experience)
		local city = self.profile:get_city()
		local new_level = (self.profile.experience-(self.profile.experience%100))/100+1

		if experience == 0 then

			message = {"Game finished! You answered "
						.. tostring(self.num_quiz.correct_answers) ..
						" questions correctly ",
						"and you received " .. experience .. " experience."}
		elseif new_level == last_level then
				message = {"Good job, you answered "
					.. tostring(self.num_quiz.correct_answers) ..
					" questions correctly! ",
					"You received " .. experience .. " experience and " .. city.country:format_balance(experience) .. "."}
		else
			message = {"Good job, you answered "
				.. tostring(self.num_quiz.correct_answers) ..
				" questions correctly! ",
				"You received " .. experience .. " experience and " .. city.country:format_balance(experience) .. ".",
				"You have now reached level " .. new_level .. "!"}
		end
		type = "message"
	else
		self.pop_up_flag_2 = true
		message = {"Are you sure you want to exit?"}
		type = "confirmation"
	end

	local subsurface = SubSurface(screen,{width = screen:get_width()*0.5,
									height = (screen:get_height()-50)*0.5,
									x = screen:get_width()*0.25,
									y = screen:get_height()*0.25+50})
	local popup_view = PopUpView(remote_control,subsurface, type, message)
	self:add_view(popup_view, true)
	self.views.grid:blur()
	self.views.num_input_comp:blur()
	self:blur()

	local button_click_func = function(button)
		if button == "ok" then
			--popup_view:destroy()
			self:destroy()
			self:trigger("exit_view")
		else
			-- This is done when cancel is pressed
			self.pop_up_flag_2 = false
			popup_view:destroy()
			self.views.grid:focus()
			self.views.num_input_comp:focus()
			self:focus()
			self._suppress_new_question = true -- Prevents the quiz from
												-- skipping a question
			self:dirty(false)
			self:dirty(true)
		end
	end

	self:listen_to_once(popup_view, "button_click", button_click_func)
	self.sub_view = popup_view
end

---Focuses the NumericalQuizView, i.e. makes it listen to the remote control
function NumericQuizView:focus()
	self:listen_to(
		event.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

---Blurs the NumericQuizView, i.e. makes it stop listening to the remote control
function NumericQuizView:blur()
	self:stop_listening(event.remote_control)
end

return NumericQuizView
