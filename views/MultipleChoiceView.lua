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
function MultipleChoiceView:__init()
	View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

	-- Flags (and similiar)
	self.listening_initiated = false
	self.end_flag = 0 -- To indicate if the quiz if complete
	self.check_question_flag = 0
	self.last_check = 1
	self.quiz_state = "IDLE" -- To keep track of quiz state
	self.areas_defined = false
	--Components

	-- Logic
	-- Associate a quiz instance with the MultipleChoiceView
	self.mult_choice_quiz = Quiz()
	self.quiz_size = 2
	self.mult_choice_quiz:generate_multiplechoice_quiz("paris",self.quiz_size)
	self.current_question = 1
	self.correct_answer_number = 0

	-- User input
	self.user_input = ""
	self.answer = {}

	-- Graphics and colors
	self.question_area_color = Color(255, 0, 0, 255)
	self.font = Font("data/fonts/DroidSans.ttf",32,Color(255,255,255,255))

	-- Buttons and grids
	self.views.grid = MultipleChoiceGrid()

	local height = screen:get_height()
	local width = screen:get_width()

	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255)
	local button_size = {width = 372, height = 107}

	-- Add back button
	local button_exit = Button(button_color, color_selected, color_disabled,
								true, true, "views.CityView")
	local exit_position = {x = 42, y = 500}
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
	local button_next = Button(button_color, color_selected, color_disabled,
								true, false, "")
	local next_position = {x = width - exit_position.x - button_size.width,
							y = exit_position.y}
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
	local button_submit = Button(button_color, color_selected, color_disabled,
								true, false, "")
	local submit_position = {x = math.ceil((width - button_size.width)/2),
							y = exit_position.y}
	button_submit:set_textdata("Submit", Color(255,255,255,255),
							{x = 0, y = 0}, 32,"data/fonts/DroidSans.ttf")
	self.views.grid:add_button(submit_position,
						button_size,
						button_submit)
	local submit_index = self.views.grid:get_last_index()
	self.views.grid:mark_as_input_comp(submit_index)

	--local submit_callback = utils.partial(self.submit)
	self:listen_to(
		self.views.grid,
		"submit",
		utils.partial(self._submit, self)
	)

	-- Question buttons
	local button_margin = 35
	local question_button_size = {width = 200, height = 60}
	local x_margin = math.ceil((width - 3 * button_margin - 4 * question_button_size.width)/2)
	local button_position_1 = {x = x_margin,
								y = 400}
	local button_position_2 = {x = x_margin + 1 * question_button_size.width + 1 * button_margin,
								y = 400}
	local button_position_3 = {x = x_margin + 2 * question_button_size.width + 2 * button_margin,
								y = 400}
	local button_position_4 = {x = x_margin + 3 * question_button_size.width + 3 * button_margin,
								y = 400}

	self.question_button_1 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")
	self.question_button_2 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")
	self.question_button_3 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")
	self.question_button_4 = ToggleButton(button_color, color_selected, color_disabled,
								true, false, "")

	self.views.grid:add_button(button_position_1,
								question_button_size,
								self.question_button_1)
	self.views.grid:add_button(button_position_2,
								question_button_size,
								self.question_button_2)
	self.views.grid:add_button(button_position_3,
								question_button_size,
								self.question_button_3)
	self.views.grid:add_button(button_position_4,
								question_button_size,
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
	print("answered")
	if self.last_check == self.current_question and self.quiz_state ~= "DONE" then
		self.user_input = self.views.grid.input
		for j = 1, #self.user_input, 1 do
			print("looping")
			if self.user_input[j] ~= nil then
				self.answer[j] = self.user_input[j]
				print("Answer j : " .. tostring(self.answer[j]))
			end
			--self.answer[j] = tonumber(string.sub(self.user_input,j,j))
		end
		if self.mult_choice_quiz.questions[self.current_question]:is_correct(self.answer) == true then
			self.correct_answer_number = self.correct_answer_number + 1
			self.result_string = "Right. You've answered "
			.. self.correct_answer_number .. " questions correctly this far."
			self.last_check = self.last_check + 1
		else
			self.result_string = "Wrong. You've answered "
			.. self.correct_answer_number .. " questions correctly this far."
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
	print("next triggered")
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
	self:trigger("exit")
end


--Responds to a button press when the View is active (i.e. current View for the
-- global @{ViewManager} instance). This method handles the logic and determines
-- what should be diplayed next to the user
function MultipleChoiceView:press(key)
	-- Determine what should happen depending on the user input and current state
	--[[if key == "right" and self.last_check == self.current_question
	and self.quiz_state ~= "DONE" then
		for j = 1, #self.user_input, 1 do
			self.answer[j] = tonumber(string.sub(self.user_input,j,j))
		end
		if self.mult_choice_quiz.questions[self.current_question]:is_correct(self.answer) == true then
			self.correct_answer_number = self.correct_answer_number + 1
			self.result_string = "Right. You've answered "
			.. self.correct_answer_number .. " questions correctly."
			self.last_check = self.last_check + 1
		else
			self.result_string = "Wrong. You've answered "
			.. self.correct_answer_number .. " questions correctly."
			self.last_check=self.last_check + 1
		end
		self.quiz_state = "DISPLAY_RESULT"
		self:dirty(true)
		--Reset user input after the answer has been initiated
		self.answer = {}
		self.user_input = ""
	elseif key == "right" and self.last_check == self.current_question + 1
		 and end_flag ~= 1 then
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
	elseif key == "right" and self.end_flag == 1 then
		-- Quiz is finished. Set up for a final result screen
		self.quiz_state = "DONE"
		self:dirty(true)
	elseif key == "back" then
		self:trigger("exit")
	else
		--Check if the user input can be interpreted as a answer and in that case
		-- append it to the current answer
		if self.user_input ~= nil and #self.user_input <= 3 then
			if(key == "1" or key == "2" or key == "3" or key == "4") then
				self.user_input = self.user_input .. key
			end
		end
	end]]
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
		self.question_area:clear(self.question_area_color)
		-- If the view is marked as dirty, re-render it
		if self.quiz_state == "IDLE" then

			--Buttons
			local button_size = {width = 372, height = 107}
			local buttonColor = {r=0, g=128, b=225}
			local textColor = Color(0,0,0,255)
			local choiceButton1 = Font("data/fonts/DroidSans.ttf",30,textColor)
			local choiceButton2 = Font("data/fonts/DroidSans.ttf",30,textColor)
			local choiceButton3 = Font("data/fonts/DroidSans.ttf",30,textColor)
			local choiceButton4 = Font("data/fonts/DroidSans.ttf",30,textColor)

			-- Draw question
			local question = self.current_question .. "."
					.. self.mult_choice_quiz.questions[self.current_question].question
			self.font:draw(self.question_area,
				{x = 0, y = 0, height = self.question_area_height,
				width = self.question_area_width},
				question, "center", "middle")

			--Button text
			--[[surface:fill(buttonColor, {width=200, height=60, x=100, y=400})
			choiceButton1:draw(surface,Rectangle(100,400,200,60):to_table(),"(1)." ..
				self.mult_choice_quiz.questions[self.current_question].Choices[1])
			surface:fill(buttonColor, {width=200, height=60, x=350, y=400})
			choiceButton2:draw(surface,Rectangle(350,400,200,60):to_table(),"(2)." ..
				self.mult_choice_quiz.questions[self.current_question].Choices[2])
			surface:fill(buttonColor, {width=200, height=60, x=600, y=400})
			choiceButton3:draw(surface,Rectangle(600,400,200,60):to_table(),"(3)." ..
				self.mult_choice_quiz.questions[self.current_question].Choices[3])
			surface:fill(buttonColor, {width=200, height=60, x=850, y=400})
			choiceButton4:draw(surface,Rectangle(850,400,200,60):to_table(),"(4)." ..
				self.mult_choice_quiz.questions[self.current_question].Choices[4])]]
			-- Question buttons
			local button_1_text =  "(1)." .. self.mult_choice_quiz.questions[self.current_question].Choices[1]
			local button_2_text =  "(2)." .. self.mult_choice_quiz.questions[self.current_question].Choices[2]
			local button_3_text =  "(3)." .. self.mult_choice_quiz.questions[self.current_question].Choices[3]
			local button_4_text =  "(4)." .. self.mult_choice_quiz.questions[self.current_question].Choices[4]

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
			local quiz_result = "You answered " .. self.correct_answer_number ..
								" questions correctly and " .. "\n" ..
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

		self.views.grid:render(surface)
	end
	-- TODO Render all child views and copy changes to this view
	-- Render children

	gfx.update()
	self:dirty(false)
end



return MultipleChoiceView
