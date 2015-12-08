--- Base class for MultipleChoiceView. View responsible for rendering the
-- multiple choice quiz
-- @classmod MultipleChoiceView
local class = require("lib.classy")
local View = require("lib.view.View")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local MultipleChoiceQuestion = require("lib.quiz.MultipleChoiceQuestion")
local Quiz = require("lib.quiz.Quiz")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local Rectangle = require("lib.draw.Rectangle")
local SubSurface = require("lib.view.SubSurface")
local ButtonGrid = require("components.ButtonGrid")
local Button = require("components.Button")
local MultipleChoiceGrid = require("components.MultipleChoiceGrid")
local ToggleButton = require("components.ToggleButton")
local ExperienceCalculation = require("lib.scores.experiencecalculation")
local PopUpView = require("views.PopUpView")

local MultipleChoiceView = class("MultipleChoiceView", View)

--- Constructor for MultipleChoiceView
-- @param remote_control The remote control bound to the memory
-- @param subsurface {@Surface} or {@SubSurface} to draw the memory on
-- @param profile The current profile used in the application
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

	self.quiz_size = 10

	self.mult_choice_quiz:generate_singlechoice_quiz(self.profile:get_current_city(),self.quiz_size)
	self.quiz_size = math.min(self.quiz_size, self.mult_choice_quiz.size)
	self.current_question = 1
	self.correct_answer_number = 0

	--Progress Bar
	self.progress_table = {}
	for i=1, #self.mult_choice_quiz.questions do
		self.progress_table[i] = -1
	end
	self.progress_counter_color = Color(255,99,0,255)
	self.progress_counter_font = Font("data/fonts/DroidSans.ttf", 32,
																	Color(255,255,255,255))

	-- User input
	self.user_input = ""
	self.answer = {}

	-- Graphics and colors
	self.question_area_color  = Color(65, 70, 72, 255)
	self.font = Font("data/fonts/DroidSans.ttf", 24, Color(255,255,255,255))

	-- Buttons and grids
	self.views.grid = MultipleChoiceGrid()

	local height = subsurface:get_height()
	local width = subsurface:get_width()

	local button_color = Color(255, 99, 0, 255)
	local color_selected = Color(255, 153, 0, 255)
	local color_disabled = Color(111, 222, 111, 255)
	local button_size = {width = 300, height = 75}

	-- Add back button
	local button_exit = Button(button_color, color_selected, color_disabled,
								true, true, "views.CityView")
	local exit_position = {x = 75, --width*0.2
 												y = 450} --height * 0.67}
	button_exit:set_textdata("Back to city", Color(255,255,255,255),
							{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")
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
								true, false)
	local next_position = {x =  width*0.8-320, y = subsurface:get_height()-150}
	button_next:set_textdata("Next question", Color(255,255,255,255),
							{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")
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

	-- Listen to the submit event, which is thrown when the user has answered a
	-- question
	self:listen_to(
		self.views.grid,
		"submit",
		utils.partial(self._submit, self)
	)

	-- Question buttons
	local button_position_1 = {x = width*0.35, y = height*0.4}
	local button_position_2 = {x = width*0.95-300, y = height*0.4}
	local button_position_3 = {x = width*0.35, y = height*0.55}
	local button_position_4 = {x = width*0.95-300, y = height*0.55}

	self.question_button_1 = ToggleButton(button_color, color_selected,
							color_disabled, true, false, "")
	self.question_button_2 = ToggleButton(button_color, color_selected,
							color_disabled, true, false, "")
	self.question_button_3 = ToggleButton(button_color, color_selected,
							color_disabled, true, false, "")
	self.question_button_4 = ToggleButton(button_color, color_selected,
							color_disabled, true, false, "")

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

	self:add_view(self.views.grid, true)

	self:focus()
	self.views.grid:select_button(3)
end

---Triggered everytime the user presses the submit button
function MultipleChoiceView:_submit()
	if self.last_check == self.current_question and self.quiz_state ~= "DONE" then
		self.user_input = self.views.grid.input
		self.answer = {}
		for j = 1, 4 do
			if self.user_input[j] ~= nil then
				table.insert(self.answer, self.user_input[j])
			end
		end
		if self.mult_choice_quiz.questions[self.current_question]:is_correct(self.answer) == true then
			self.correct_answer_number = self.correct_answer_number + 1
			self.result_string = "Correct! You've answered "
			.. self.correct_answer_number .. " questions correctly this far."
			self.progress_table[self.current_question] = true
			self.last_check = self.last_check + 1
		else
			local correct_alternative_no = tostring(self.mult_choice_quiz.questions[self.current_question].correct_answers[1])
			local alternative_map = {}
			alternative_map["1"] = "A"
			alternative_map["2"] = "B"
			alternative_map["3"] = "C"
			alternative_map["4"] = "D"
			local correct_alternative = alternative_map[correct_alternative_no]
			self.result_string = "Wrong. " ..
								"The correct alternative was alternative "
								.. correct_alternative .. "."
			self.progress_table[self.current_question] = false
			self.last_check=self.last_check + 1
		end
		if self.current_question == self.quiz_size then
			--The quiz is completeted. State changed to DONE, which prompts
			-- the pop-up
			self.quiz_state = "DONE"
			self:dirty(true)
		else
			self.views.grid:select_next()
			self.quiz_state = "DISPLAY_RESULT"
			self:dirty(true)
		end
		--Reset user input after the answer has been displayed
		self.answer = {}
		self.user_input = ""
	end
end

---Triggered everytime the user presses the next button
function MultipleChoiceView:_next()
	if self.end_flag ~= 1 then
		-- Next question is displayed
		-- Make sure there are questions left to display
		self.current_question = self.current_question + 1
		if self.current_question > self.quiz_size then
			self.end_flag = 1
			self.quiz_state = "DONE"
		else
			self.quiz_state = "IDLE"
		end
		self.views.grid:select_button(3)
		self:dirty(true)
	elseif self.end_flag == 1 then
		-- Quiz is finished. Set up for a final result screen
		self.quiz_state = "DONE"

		local counter  = self.correct_answer_number
		local experience = ExperienceCalculation.Calculation(counter, "Multiplechoice")
		self.profile:modify_balance(experience)
		self.profile:modify_experience(experience)
	end
end

--- Destroys the quiz view and exits teh mini game. Triggered when the user
-- presses the back to city button
function MultipleChoiceView:_exit()
	self.pop_up_flag_2 = true
	self:dirty(false)
	self:dirty(true)
	--[[local type = "confirmation"
	local message = {"Are you sure you want to exit?"}
	self:_back_to_city(type, message)]]
end


---Responds to a button press when the View is active (i.e. current View for the
-- global @{ViewManager} instance). This method handles the logic and determines
-- what should be diplayed next to the user
-- @param key Key that was pressed
function MultipleChoiceView:press(key)
	if key == "red" then
		self:_exit()
	end
end

---Renders this instance of MultipleChoiceView and all its child views, given
-- that it's flagged as dirty
-- @param surface @{Surface} or @{SubSurface} to render this view on
function MultipleChoiceView:render(surface)
		local surface_width = surface:get_width()
		local surface_height = surface:get_height()
		surface:clear(color)
		local pop_up_flag = false
		-- If the areas haven't been defined yet, define them
		if not self.areas_defined then
			-- Question area
			local x = 400
			local y = 75
			--self.question_area_width = surface_width - 2 * x
			self.question_area_width = surface_width * 0.6
			self.question_area_height = math.ceil(0.20*surface_height)

			self.question_area_back = SubSurface(surface, {x = surface_width * 0.35, y = y,
				height = self.question_area_height,
				width = self.question_area_width})

			self.question_area = SubSurface(surface, {x = surface_width * 0.35 + 5, y = y + 5 ,
				height = self.question_area_height - 10,
				width = self.question_area_width - 10})

			self.areas_defined = true
		end
		self.question_area_back:clear(Color(250, 105, 0, 255):to_table())
		self.question_area:clear(self.question_area_color:to_table())

		-- If the view is marked as dirty, re-render it
		if self.quiz_state == "IDLE" then

			-- Draw question
			local question_nr = self.current_question .. ". "
			local question = self.mult_choice_quiz.questions[self.current_question].question
			local new_question = ""
			local str_len = string.len(question)
			local count_from_break = 0
			local yq = 15

			-- If the question is too long, this is where it is printed in
			-- several lines
			if str_len >= 60 then
			for j = 1, (math.ceil(str_len/60) + 1) do
				local new_str_len = string.len(string.sub(question,
								(j-1) * 60 + 1 - count_from_break, str_len))
					for i = 0, 100 do
						if string.sub(question,
									j*60-i-count_from_break,
									j*60-i-count_from_break) == " " then
							if new_str_len < 60 then
								new_question = string.sub(question,
										(j-1)*60 + 1 - count_from_break,str_len)
								self.font:draw(self.question_area,
											{x = 0, y = yq,
											height = self.question_area_height,
											width = self.question_area_width},
											new_question, "center")
								break
							else
								new_question = string.sub(question,
												(j-1)*60+1-count_from_break,
												j*60-i-count_from_break) .. "\n"
								count_from_break = count_from_break + i
								self.font:draw(self.question_area,
											{x = 0, y = yq,
											height = self.question_area_height,
											width = self.question_area_width},
											new_question, "center")
								yq = 10 + j*35
								break
							end
					end
				end
			end
			count_from_break = 0
			yq = 15
		end

			if new_question == "" then
				new_question = question
				self.font:draw(self.question_area,
					{x = 0, y = 0, height = self.question_area_height,
					width = self.question_area_width},
					new_question, "center", "middle")
			end

			local button_1_text =  "A. " .. self.mult_choice_quiz.questions[self.current_question].Choices[1]
			local button_2_text =  "B. " .. self.mult_choice_quiz.questions[self.current_question].Choices[2]
			local button_3_text =  "C. " .. self.mult_choice_quiz.questions[self.current_question].Choices[3]
			local button_4_text =  "D. " .. self.mult_choice_quiz.questions[self.current_question].Choices[4]

			self.question_button_1:set_textdata(button_1_text, Color(255,255,255,255),
										{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")

			self.question_button_2:set_textdata(button_2_text, Color(255,255,255,255),
										{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")

			self.question_button_3:set_textdata(button_3_text, Color(255,255,255,255),
										{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")

			self.question_button_4:set_textdata(button_4_text, Color(255,255,255,255),
										{x = 0, y = 0}, 24,"data/fonts/DroidSans.ttf")

		elseif self.quiz_state == "DISPLAY_RESULT" then
			-- Display the result from one question
			local result = self.result_string
			self.font:draw(self.question_area,
				{x = 0, y = 0, height = self.question_area_height,
				width = self.question_area_width},
				result, "center", "middle")
		elseif self.quiz_state == "DONE" then
			pop_up_flag = true
		end

		local left_board = SubSurface(surface,{width = 300, height = surface:get_height()-150, x = 75, y = 75})

		left_board:clear(Color(250, 105, 0, 255):to_table())
		left_board:fill({r = 65, g = 70, b = 72, a = 255},
			{x = 5, y = 5, width = 290, height = surface:get_height()-160})

		left_board:fill(Color(250, 105, 0, 255):to_table(),
			{x = 5, y = 75, width = 290, height = 5})
		local text_color = Color(255,255,255,255)
		local text = Font("data/fonts/DroidSans.ttf", 30, text_color)
			text:draw(left_board, {x = 50, y = 20}, "Multiple Choice")
			text:draw(left_board, {x = 72, y = 130}, "Question " .. self.current_question)

		--Progress counter
		local progress_margin = 26
		self.counter_width = 72
		self.counter_height = 72
		self.x_counter = 50--math.ceil(surface_width - progress_margin -
									--self.counter_width)
		self.y_counter = 250--progress_margin
		self.progress_counter_area = SubSurface(surface, {x = self.x_counter,
									y = self.y_counter,
									height = self.counter_height,
									width = self.counter_width})

		-- Render the Progress counter
	--	self.progress_counter_area:clear(self.progress_counter_color:to_table())
		local current_question = self.current_question
		local quiz_length = #self.mult_choice_quiz.questions
		local current_question = math.min(current_question, quiz_length)
	--	self.progress_counter_font:draw(self.progress_counter_area,
	--								{x = 0, y = 0, height = self.counter_height,
	--								width = self.counter_width},
	--								tostring(current_question) .. "/" ..
	--								tostring(quiz_length), "center", "middle")
		-- Render the Progress bar
		local bar_component_width = 35
		local bar_component_height = 35
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
										{x = bar_component_x, y = bar_component_y,
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
		--	bar_component_y = bar_component_y + progress_bar_margin +
			--					bar_component_height

			bar_component_x = bar_component_x + bar_component_width + progress_bar_margin_x
					if i % 5 == 0 then
							bar_component_x = self.x_counter + self.counter_width -
																			bar_component_width + 32
							bar_component_y = bar_component_y + progress_bar_margin_y +
																			bar_component_height - 17
					end
		end


		self.prevent = false

		self.views.grid:render(surface)
		if pop_up_flag then
			local counter  = self.correct_answer_number
			local experience = ExperienceCalculation.Calculation(counter, "Multiplechoice")
			local last_level = (self.profile.experience-(self.profile.experience%100))/100+1
			self.profile:modify_balance(experience)
			self.profile:modify_experience(experience)
			local city = self.profile:get_city()
			local new_level = (self.profile.experience-(self.profile.experience%100))/100+1
			local type = "message"
			local message = ""
			if experience == 0 then
				message = {"Game finished! You answered " .. tostring(self.correct_answer_number)..
				" questions correctly and",  "received " .. experience .. " experience."}
			elseif last_level == new_level then
				message = {"Good job, you answered "
						.. tostring(self.correct_answer_number) ..
						" questions correctly! ",
						"You received " .. experience .. " experience and " .. city.country:format_balance(experience) .. "."}
			else
				message = {"Good job, you answered "
					.. tostring(self.correct_answer_number) ..
					" questions correctly! ",
					"You received " .. experience .. " experience and " .. city.country:format_balance(experience) .. ".",
					"You have now reached level " .. new_level .. "!"}
			end
			self:_back_to_city(type, message)
		elseif self.pop_up_flag_2 then
			local type = "confirmation"
			local message = {"Are you sure you want to exit?"}
			self:_back_to_city(type, message)
		end
	self:dirty(false)
end

---Function that triggers the end of game pop
--@param type String representing the type of pop-up.
--@param message String with message to display
function MultipleChoiceView:_back_to_city(type, message)
    local subsurface = SubSurface(screen,
									{width = screen:get_width() * 0.5,
									height = (screen:get_height() - 50) * 0.5,
									x = screen:get_width() * 0.25,
									y = screen:get_height() * 0.25 + 50})
	local popup_view = PopUpView(remote_control,subsurface, type, message)
    self:add_view(popup_view)
    self.views.grid:blur()
	self:blur()

    local button_click_func = function(button)
      	if button == "ok" then
		  	self:destroy()
      		self:trigger("exit_view")
      	else
			self.pop_up_flag_2 = false
	      	popup_view:destroy()
	      	self.views.grid:focus()
	      	self:dirty(true)
    	end
    end

    self:listen_to_once(popup_view, "button_click", button_click_func)
    popup_view:render(subsurface)
end

---Focuses the {@MultipleChoiceView}, which makes it listen to the remote control
function MultipleChoiceView:focus()
 	self:listen_to(
 	event.remote_control,
 	"button_release",
	utils.partial(self.press, self)
)
end

---Blurs the {@MultipleChoiceView}, which stops it listening to the
-- remote control
function MultipleChoiceView:blur()
	self:stop_listening(event.remote_control)
end

return MultipleChoiceView
