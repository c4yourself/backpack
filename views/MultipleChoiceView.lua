--- Base class for MultipleChoiceView.
-- @classmod MultipleChoiceView
-- MultipleChoiceView is the view responsible for rendering the multiple choice quiz
local class = require("lib.classy")
local View = require("lib.view.View")
local MultipleChoiceView = class("MultipleChoiceView", View)
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local MultipleChoiceQuestion = require("lib.quiz.MultipleChoiceQuestion")
local Quiz = require("lib.quiz.Quiz")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local Rectangle = require("lib.draw.Rectangle")
local SubSurface = require("lib.view.SubSurface")
local ButtonGrid = require("lib.components.ButtonGrid")
local Button = require("lib.components.Button")
local MultipleChoiceGrid = require("lib.components.MultipleChoiceGrid")
local NumericalQuizGrid = require("lib.components.NumericalQuizGrid")
local ToggleButton = require("lib.components.ToggleButton")

--- Constructor for MultipleChoiceView
function MultipleChoiceView:__init(remote_control, subsurface, profile)
	View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented
	self.profile = profile
	-- Flags (and similiar)
	self.listening_initiated = false
	self.end_flag = 0 -- To indicate if the quiz if complete
	self.check_question_flag = 0
	self.last_check = 1
	self.quiz_state = "IDLE" -- To keep track of quiz state
	self.areas_defined = false

	-- Logic
	-- Associate a quiz instance with the MultipleChoiceView
	self.mult_choice_quiz = Quiz()
	self.quiz_size = 2
	self.mult_choice_quiz:generate_citytour_quiz(self.profile:get_current_city(),self.quiz_size,1)
	self.current_question = 1
	self.correct_answer_number = 0

	--Progress Bar
	self.progress_table = {}
	for i=1, #self.mult_choice_quiz.questions do
		self.progress_table[i] = -1
	end
	self.progress_counter_color = Color(0,255,0,255)

	-- User input
	self.user_input = ""
	self.answer = {}

	-- Graphics and colors
	self.question_area_color = Color(255, 255, 255, 255)
	self.font = Font("data/fonts/DroidSans.ttf", 24, Color(0,0,0,255))

	-- Buttons and grids
	self.views.grid = MultipleChoiceGrid()

	local height = screen:get_height()
	local width = screen:get_width()

	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 255, 255, 55)
	local color_disabled = Color(111, 222, 111, 255)
	local button_size = {width = 300, height = 75}

	-- Add back button
	local button_exit = Button(Color(255,35,35,255), color_selected, color_disabled,
								true, true, "views.CityView")
	local exit_position = {x = width*0.07, y = 0.7*height}
	button_exit:set_textdata("Back to city", Color(255,255,255,255),
							{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(exit_position,
						button_size,
						button_exit)
	local exit_index = self.views.grid:get_last_index()
	self.views.grid:mark_as_back_button(exit_index)

	self:listen_to(
		self.views.grid,
		"back",
		utils.partial(self._exit, self)
	)

	-- Add next button
	local button_next = Button(Color(250, 169, 0,255), color_selected, color_disabled,
								true, false, "")
	local next_position = {x = width*0.55, y = height*0.67}
	button_next:set_textdata("Next question", Color(255,255,255,255),
							{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(next_position,
						button_size,
						button_next)
	local next_index = self.views.grid:get_last_index()
	self.views.grid:mark_as_next_button(next_index)

	self:listen_to(
		self.views.grid,
		"next",
		utils.partial(self._next, self)
	)

	-- Add submit button
	local button_submit = Button(Color(0,102,0,255), color_selected, color_disabled,
								true, false, "")
	local submit_position = {x = width*0.25, y = height * 0.67}
	button_submit:set_textdata("Next question", Color(255,255,255,255),
							{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(submit_position,
						button_size,
						button_submit)
	local submit_index = self.views.grid:get_last_index()

	self.views.grid:mark_as_input_comp(submit_index)
--self.views.grid:mark_as_next_button(next_index)
	--local submit_callback = utils.partial(self.submit)
	self:listen_to(
		self.views.grid,
		"submit",
		utils.partial(self._submit, self)
	)

	-- Question buttons
	--local button_margin = 35
	--local x_margin = math.ceil((width - 3 * button_margin - 4 * question_button_size.width)/2)
	local button_position_1 = {x = width*0.25, y = height*0.33}
	local button_position_2 = {x = width*0.55, y = height*0.33}
	local button_position_3 = {x = width*0.25, y = height*0.47}
	local button_position_4 = {x = width*0.55, y = height*0.47}

	self.question_button_1 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")
	self.question_button_2 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")
	self.question_button_3 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")
	self.question_button_4 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")

	self.views.grid:add_button(button_position_1,
								button_size,
								self.question_button_1)
	self.views.grid:add_button(button_position_2,
								button_size,
								self.question_button_2)
	self.views.grid:add_button(button_position_3,
								button_size,
								self.question_button_3)
	self.views.grid:add_button(button_position_4,
								button_size,
								self.question_button_4)

	-- Listeners and callbacks
	self:listen_to(
	event.remote_control,
	"button_release",
	utils.partial(self.press, self)
	)
end

---Triggered everytime the user presses the submit button
function MultipleChoiceView:_submit()
	if self.last_check == self.current_question and self.quiz_state ~= "DONE" then
		self.user_input = self.views.grid.input
		self.answer = {}
		for j = 1, 4 --[[#self.user_input]] do
			if self.user_input[j] ~= nil then
				--self.answer[j] = self.user_input[j]
				table.insert(self.answer, self.user_input[j])
			end
			--self.answer[j] = tonumber(string.sub(self.user_input,j,j))
		--self.mult_choice_quiz.current_question = self.mult_choice_quiz.current_question + 1
		end
		if self.mult_choice_quiz.questions[self.current_question]:is_correct(self.answer) == true then
			self.correct_answer_number = self.correct_answer_number + 1
			self.result_string = "Correct! You've answered "
			.. self.correct_answer_number .. " questions correctly this far."
			self.progress_table[self.current_question] = true
			self.last_check = self.last_check + 1
		else
			self.result_string = "Wrong. You've answered "
			.. self.correct_answer_number .. " questions correctly this far."
			self.progress_table[self.current_question] = false
			self.last_check=self.last_check + 1
		end
		self.quiz_state = "DISPLAY_RESULT"
		self:dirty(true)
		--Reset user input after the answer has been initiated
		self.answer = {}
		self.user_input = ""
	end
end

---Triggered everytime the user presses the next button
function MultipleChoiceView:_next()
	if end_flag ~= 1 then
		-- Next question is displayed
		-- Make sure there are questions left to display
		self.current_question = self.current_question + 1
		if self.current_question > self.quiz_size then
			end_flag = 1
			self.quiz_state = "DONE"
		else
			self.quiz_state = "IDLE"
		end
		self:dirty(true)
	elseif self.end_flag == 1 then
		-- Quiz is finished. Set up for a final result screen
		self.quiz_state = "DONE"
		self:dirty(true)
	end
end

---Triggered everytime the user presses the back to city button
function MultipleChoiceView:_exit()
	--TODO add popup
	self:trigger("exit_view", self.profile)
end


--Responds to a button press when the View is active (i.e. current View for the
-- global @{ViewManager} instance). This method handles the logic and determines
-- what should be diplayed next to the user
function MultipleChoiceView:press(key)
end

--Renders this instance of MultipleChoiceView and all its child views, given
-- that it's flagged as dirty
function MultipleChoiceView:render(surface)
	if not self.listening_initiated then
		-- If this view are not listening to all the components it should
		-- listen to yet: start listening
		local callback = utils.partial(self.press)

		self:listen_to(
			event.remote_control,
			"button_release",
			callback
		)

		self:listen_to(
			self.views.grid,
			"dirty",
			utils.partial(self.views.grid.render,
							self.views.grid, surface)
		)

		-- TODO initiate listening to the button group, when its implemented
		self.listening_initiated = true
	end

	if self:is_dirty() then
		local surface_width = surface:get_width()
		local surface_height = surface:get_height()
		surface:clear(color)

		-- If the areas haven't been defined yet, define them
		if not self.areas_defined then
			-- Question area
			local x = math.ceil(surface:get_width() * 0.2)
			local y = math.ceil(surface:get_height() * 0.1)
			self.question_area_width = surface_width - 2 * x
			self.question_area_height = math.ceil(0.17*surface_height)

			self.question_area = SubSurface(surface, {x = x, y = y,
				height = self.question_area_height,
				width = self.question_area_width})

			self.areas_defined = true
		end
		self.question_area:clear(self.question_area_color:to_table())

		-- If the view is marked as dirty, re-render it
		if self.quiz_state == "IDLE" then

			-- Draw question
			local question = self.current_question .. ". "
					.. self.mult_choice_quiz.questions[self.current_question].question
			self.font:draw(self.question_area,
				{x = 0, y = 0, height = self.question_area_height,
				width = self.question_area_width},
				question, "center", "middle")
			local button_1_text =  "A. " .. self.mult_choice_quiz.questions[self.current_question].Choices[1]
			local button_2_text =  "B. " .. self.mult_choice_quiz.questions[self.current_question].Choices[2]
			local button_3_text =  "C. " .. self.mult_choice_quiz.questions[self.current_question].Choices[3]
			local button_4_text =  "D. " .. self.mult_choice_quiz.questions[self.current_question].Choices[4]

			self.question_button_1:set_textdata(button_1_text, Color(255,255,255,255),
										{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")

			self.question_button_2:set_textdata(button_2_text, Color(255,255,255,255),
										{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")

			self.question_button_3:set_textdata(button_3_text, Color(255,255,255,255),
										{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")

			self.question_button_4:set_textdata(button_4_text, Color(255,255,255,255),
										{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")

		elseif self.quiz_state == "DISPLAY_RESULT" then
			-- Display the result from one question
			-- self.font:draw(screen,Rectangle(100,300,200,200):to_table(),self.result_string)
			local result = self.result_string
			self.font:draw(self.question_area,
				{x = 0, y = 0, height = self.question_area_height,
				width = self.question_area_width},
				result, "center", "middle")
		elseif self.quiz_state == "DONE" then
			-- Display the result from the whole quiz
			self.mult_choice_quiz:calculate_score(self.correct_answer_number)
			local quiz_result = "You've answered " .. self.correct_answer_number ..
								" questions correctly and " .. --"\n" ..
								" your final score is " ..
								self.mult_choice_quiz:get_score() .. "."
			self.font:draw(self.question_area,
				{x = 0, y = 0, height = self.question_area_height,
				width = self.question_area_width},
				quiz_result, "center", "middle")
			--[[self.font:draw(screen,Rectangle(100,300,200,200):to_table(),"You answered "
			.. self.correct_answer_number .. " questions correctly and your score is "
			.. self.mult_choice_quiz:get_score() .. ".")]]
		end

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
		-- Render the Progress counter
		self.progress_counter_area:clear(self.progress_counter_color:to_table())
		local current_question = self.current_question
		local quiz_length = #self.mult_choice_quiz.questions
		local current_question = math.min(current_question, quiz_length)
		self.font:draw(self.progress_counter_area,
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
			progress_bar_component:clear(bar_component_color:to_table())
			bar_component_y = bar_component_y + progress_bar_margin +
								bar_component_height
		end
		self.prevent = false

		self.views.grid:render(surface)
	end

	-- TODO Render all child views and copy changes to this view
	-- Render children

	gfx.update()
	self:dirty(false)
end


return MultipleChoiceView
