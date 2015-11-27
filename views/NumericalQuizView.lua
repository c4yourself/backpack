--- Base class for NumericQuizView
-- @classmod NumericQuizView
local NumericalInputComponent = require("components.NumericalInputComponent")
local class = require("lib.classy")
local View = require("lib.view.View")
local NumericQuizView = class("NumericQuizView", View)
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local Quiz = require("lib.quiz.Quiz")
local NumericQuestion = require("lib.quiz.NumericQuestion")
local SubSurface = require("lib.view.SubSurface")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local NumericalQuizGrid = require("lib.components.NumericalQuizGrid")
local Button = require("lib.components.Button")

--- Constructor for NumericQuizView
function NumericQuizView:__init()
	View.__init(self)
	--event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

	-- Flags
	--Flags to determine whether a quiz or a question is answered
	self.answer_flag = false
	self.quiz_flag = false
	self.listening_initiated = false
	self.input_area_defined = false
	self.areas_defined = false
	self.prevent = false -- This flag is used for avoiding bug where render is
						-- called twice upon a submit.
	--Components
	self.views.grid = NumericalQuizGrid(remote_control)
	--Instanciate a numerical input component and make the quiz listen for changes
	self.views.num_input_comp = NumericalInputComponent()

	--Button data
	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255)

	local height = screen:get_height()
	local width = screen:get_width()
	local button_size = {width = 372, height = 107}

	-- Add exit button
	local button_exit = Button(button_color, color_selected, color_disabled,
								true, true, "views.CityView")
	local exit_position = {x = 42, y = 450}
	button_exit:set_textdata("Back to city", Color(255,255,255,255),
							{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(exit_position,
						button_size,
						button_exit)
	local exit_index = self.views.grid:get_last_index()
	self.views.grid:mark_as_back_button(exit_index)
	-- Add next button
	local button_next = Button(button_color, color_selected, color_disabled,
								true, false, "")
	local next_position = {x = 0.9 * width - exit_position.x - button_size.width,
							y = exit_position.y}
	button_next:set_textdata("Next question", Color(255,255,255,255),
							{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(next_position,
						button_size,
						button_next)
	local next_index = self.views.grid:get_last_index()
	self.views.grid:mark_as_next_button(next_index)

	-- Logic
	-- Associate a quiz instance with the View
	self.num_quiz = Quiz()
	self.progress_table = {}
	self.num_quiz:generate_numerical_quiz("NOVICE", 5+1, "image_path")
	for i=1, #self.num_quiz.questions do
		self.progress_table[i] = -1
	end
	self.user_answer = ""

	-- Background colors for this view's own subsurfaces
	self.question_area_color = Color(255,0,0,255)
	self.progress_counter_color = Color(0,255,0,255)
	self.question_area_font = Font("data/fonts/DroidSans.ttf", 32,
									Color(255,255,255,255))
	-- Listeners and callbacks
	self:listen_to(
		event.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

---Responds to a button press when the View is active
-- @param key Key that was pressed
function NumericQuizView:press(key)
 	if key == "back" then
		self:back_to_city()
	end
end

---Renders a NumericQuizView and all its child views
--@param surface Surface or SubSurface to render upon
function NumericQuizView:render(surface)
	local surface_width = surface:get_width()
	local surface_height = surface:get_height()

	-- Define input area if it hasn't been done already
	if not self.input_area_defined then
		local input_x = math.ceil(surface:get_width() * 0.4)
		local input_y = math.ceil(surface:get_height() * 0.6)
		local input_height = math.ceil(0.2 * surface_height)
		local input_width = math.ceil(0.2 * surface_width)
		self.input_area = SubSurface(surface, {x = input_x, y = input_y,
									height = input_height,
									width = input_width})
		self.views.grid:add_button({x = input_x, y = input_y},
							{height = input_height , width = input_width},
							self.views.num_input_comp)
		local input_index = self.views.grid:get_last_index()
		self.views.grid:mark_as_input_comp(input_index)
	end

	-- Render the view as long as it isn't clean already
	if self:is_dirty() then
		local color = nil -- Background color for the quiz
		surface:clear(color)
		-- Define other areas if it hasn't been done already
		if not self.areas_defined then
			--Progress counter
			local progress_margin = 26
			self.counter_width = 72
			self.counter_height = 72
			self.x_counter = math.ceil(surface_width - progress_margin -
										self.counter_width)
			self.y_counter = progress_margin
			self.progress_counter_area = SubSurface(surface, {x = self.x_counter,
										y = self.y_counter,
										height = self.counter_height,
										width = self.counter_width})
			--Question area
			local x = math.ceil(surface:get_width() * 0.2)
			local y = math.ceil(surface:get_height() * 0.2)
			local question_area_width = surface_width - 2 * x
			local question_area_height = math.ceil(0.3*surface_height)
			self.question_area_width = question_area_width
			self.question_area_height = question_area_height

			self.question_area = SubSurface(surface, {x = x, y = y,
				height = question_area_height,
				width = question_area_width})

			self.areas_defined = true
		end
		-- Question area
		self.question_area:clear(self.question_area_color)

		--Determine what should be shown in the Question area
		if self.answer_flag then
			-- The user has answered a question
			local current_question = self.num_quiz.current_question
			if self.num_quiz:answer(self.user_answer) then
				output = "Correct!"
				self.progress_table[current_question] = true
			else
				output = "False. You answered " .. tostring(self.user_answer) ..
				 " and" .. "\n" .. "the correct answer was "
				 .. tostring(self.num_quiz.questions[current_question].correct_answer) .. "."
				self.progress_table[current_question] = false
			end
			self.question_area_font:draw(self.question_area,
				{x = 0, y = 0, height = self.question_area_height,
				width = self.question_area_width},
				output, "center", "middle")
			self.answer_flag = false
			-- The statements below was useful for finding a bug, leaving them
			-- in case it re-occurs
			--print("Correct answers: " .. tostring(self.num_quiz.correct_answers))
			--print("Wrong answers: " .. tostring(self.num_quiz.wrong_answers))
		else
			-- Show a new question if there is one, otherwise show final result
			self.answer_flag = false
			local question = self.num_quiz:get_question()
			if question ~= nil then
				local question_text = "What is the answer to: " .. question .. "?"
				self.question_area_font:draw(self.question_area, {x = 0, y = 0,
					height = self.question_area_height,
					width = self.question_area_width},
					question_text, "center", "middle")
			else
				-- The user has finished the quiz
				self.views.num_input_comp:blur()
				self.quiz_flag = true
				local output = "You answered "
								.. tostring(self.num_quiz.correct_answers)
								.. " questions correctly."
				self.question_area_font:draw(self.question_area, {x = 0, y = 0,
								height = self.question_area_height,
								width = self.question_area_width},
								output, "center", "middle")
			end
		end
		-- Render the Progress counter
		self.progress_counter_area:clear(self.progress_counter_color)
		local current_question = self.num_quiz.current_question
		local quiz_length = #self.num_quiz.questions
		local current_question = math.min(self.num_quiz.current_question,
												quiz_length)
		self.question_area_font:draw(self.progress_counter_area,
									{x = 0, y = 0, height = self.counter_height,
									width = self.counter_width},
									tostring(current_question) .. " / " ..
									tostring(quiz_length), "center", "middle")
		-- Render the Progress bar
		local bar_component_width = 45
		local bar_component_height = 45
		local progress_bar_margin = 10
		local bar_component_x = self.x_counter + self.counter_width -
								bar_component_width
		local bar_component_y = self.y_counter + progress_bar_margin +
								self.counter_height
		local quiz_length = #self.progress_table
		-- Create a progress bar and color its boxes
		for i = 1, quiz_length do
			local progress_bar_component = SubSurface(surface,
										{x = bar_component_x, y = bar_component_y,
										height = bar_component_height,
										width = bar_component_width})
			local bar_component_color = nil
			-- Depending on the users success: color the boxes differently
			if self.progress_table[i] == true then
				bar_component_color = Color(0,255,0,255)
			elseif self.progress_table[i] == false then
				bar_component_color = Color(255,0,0,255)
			else
				bar_component_color = Color(255, 255, 255, 255)
			end
			progress_bar_component:clear(bar_component_color)
			bar_component_y = bar_component_y + progress_bar_margin +
								bar_component_height
		end
		self.prevent = false
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
			self.views.num_input_comp,
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
		self:listen_to(
			self.views.grid,
			"back",
			utils.partial(self.back_to_city, self)
		)

		self.listening_initiated = true
	end

	self:dirty(false)
	self.views.grid:render(surface)
	gfx.update()
end

--- Set up for showing whether the user answered correctly or not. Only works
-- when the user has entered an answer in the input field. Triggers dirty
function NumericQuizView:show_answer()
	if self.views.num_input_comp:get_text() ~= "" then
		if not self.prevent then
			self.prevent = not self.prevent
			self.answer_flag = true
			self.user_answer = tonumber(self.views.num_input_comp:get_text())
			self.views.num_input_comp:set_text(nil)
			self:dirty(false)
			self:dirty(true)
		end
	end
end

--- Set up for the next question in the quiz. Triggers dirty
function NumericQuizView:next_question()
	self.answer_flag = false
	self.prevent = false
	self.user_answer = nil
	self.views.num_input_comp:set_text(nil)
	self:dirty(false)
	self:dirty(true)
end

function NumericQuizView:back_to_city()
	--TODO Add pop-up
	self:trigger("exit_view")
	self:destroy()
end

return NumericQuizView
