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
	--Components

	-- Logic
	-- Associate a quiz instance with the MultipleChoiceView
	self.mult_choice_quiz = Quiz()
	self.quiz_size = 2
	self.mult_choice_quiz:generate_citytour_quiz(self.profile:get_current_city(),self.quiz_size,1)
	self.current_question = 1
	self.correct_answer_number = 0

	-- User input
	self.user_input = ""
	self.answer = {}

	-- Graphics
	self.font = Font("data/fonts/DroidSans.ttf",32,Color(255,255,255,255))
	-- Listeners and callbacks
	self:listen_to(
	event.remote_control,
	"button_release",
	utils.partial(self.press, self)
	)
end

--Responds to a button press when the View is active (i.e. current View for the
-- global @{ViewManager} instance). This method handles the logic and determines
-- what should be diplayed next to the user
function MultipleChoiceView:press(key)
	-- Determine what should happen depending on the user input and current state
	if key == "right" and self.last_check == self.current_question
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
	end
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
		-- TODO initiate listening to the button group, when its implemented
		self.listening_initiated = true
	end

	if self:is_dirty() then
		-- If the view is marked as dirty, re-render it
		if self.quiz_state == "IDLE" then
			surface:clear(color)
			--Buttons
			local buttonColor = {r=0, g=128, b=225}
			--local textColor = {r=0, g=0, b=0}
			local textColor = Color(0,0,0,255)
			local choiceButton1 = Font("data/fonts/DroidSans.ttf",30,textColor)
			local choiceButton2 = Font("data/fonts/DroidSans.ttf",30,textColor)
			local choiceButton3 = Font("data/fonts/DroidSans.ttf",30,textColor)
			local choiceButton4 = Font("data/fonts/DroidSans.ttf",30,textColor)

			-- Draw question
			self.font:draw(surface,Rectangle(100,300,200,200):to_table(),self.current_question ..
			"." .. self.mult_choice_quiz.questions[self.current_question].question)
			--Button text
			surface:fill(buttonColor, {width=200, height=60, x=100, y=400})
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
				self.mult_choice_quiz.questions[self.current_question].Choices[4])

		elseif self.quiz_state == "DISPLAY_RESULT" then
			-- Display the result from one question
			surface:clear(color)
			self.font:draw(screen,Rectangle(100,300,200,200):to_table(),self.result_string)
		elseif self.quiz_state == "DONE" then
			-- Display the result from the whole quiz
			surface:clear(color)
			self.mult_choice_quiz:calculate_score(self.correct_answer_number)
			self.font:draw(screen,Rectangle(100,300,200,200):to_table(),"You answered "
			.. self.correct_answer_number .. " questions correctly and your score is "
			.. self.mult_choice_quiz:get_score() .. ".")
		end
	end
	-- TODO Render all child views and copy changes to this view
	-- Render children

	gfx.update()
	self:dirty(false)
end

return MultipleChoiceView
