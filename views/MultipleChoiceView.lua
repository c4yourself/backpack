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

--- Constructor for MultipleChoiceView
function MultipleChoiceView:__init()
	View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

	-- Flags
	self.listening_initiated = false
	self.end_flag=0
	self.check_question_flag=0
	self.last_check=0
	--Components

	-- Logic
	-- Associate a quiz instance with the MultipleChoiceView
	self.mult_choice_quiz = Quiz()
	self.mult_choice_quiz:generate_multiplechoice_quiz("paris",10)

	--mulchoice_quiz:generate_multiplechoice_quiz("image_path",10)
	--mulchoice_quiz:get_choices()
	--local multiplechoice_quiz={}

	-- User input
	self.user_input=""
	self.answer={}

	-- Graphics
	self.font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))

	-- Listeners and callbacks
	self:listen_to(
		event.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

--Responds to a button press when the View is active (i.e. current View for the
-- global @{ViewManager} instance)
function MultipleChoiceView:press(key)
	-- Determine what should happen next
	if key=="right" and self.last_check==i  then
		for j=1,#self.user_input,1 do
			self.answer[j]=tonumber(string.sub(self.user_input,j,j))
		end
		--print(self.mult_choice_quiz.questions[i]:is_correct(answer))
		if self.mult_choice_quiz.questions[i]:is_correct(answer)==true then
			local correct_answer_number=correct_answer_number+1
			-- surface:clear(color)
			-- font:draw_over_surface(screen, "Right and You answered " .. correct_answer_number .. " questions correctly.")
			self.last_check=last_check+1
		else
			--surface:clear(color)
			--font:draw_over_surface(screen, "Wrong and You answered " .. correct_answer_number .. " questions correctly.")
			self.last_check=last_check+1
		end
		self.answer={}
		self.user_input=""
	--display the next question
	elseif key=="right" and self.last_check==i+1 and end_flag~=1 then
		if i<10  then
			i=i+1
			--print (mulchoice_quiz.questions[i].question)
			--surface:clear(color)
			--[[font:draw_over_surface(screen,i .. "." .. mulchoice_quiz.questions[i].question)
			surface:fill(buttonColor, {width=200, height=60, x=100, y=400})
			choiceButton1:draw_over_surface(surface,"(1)." .. mulchoice_quiz.questions[i].Choices[1])
			surface:fill(buttonColor, {width=200, height=60, x=350, y=400})
			choiceButton2:draw_over_surface(surface,"(2)." .. mulchoice_quiz.questions[i].Choices[2])
			surface:fill(buttonColor, {width=200, height=60, x=600, y=400})
			choiceButton3:draw_over_surface(surface,"(3)." .. mulchoice_quiz.questions[i].Choices[3])
			surface:fill(buttonColor, {width=200, height=60, x=850, y=400})
			choiceButton4:draw_over_surface(surface,"(4)." .. mulchoice_quiz.questions[i].Choices[4])]]
			if i==10 then
				end_flag=1
			end
		end
	-- display final result
	elseif key=="right" and self.end_flag==1 then
			self.mult_choice_quiz.questions:calculate_score(correct_answer_number)
			--surface:clear(color)
			--font:draw_over_surface(screen, "You answered " .. correct_answer_number .. " questions correctly and your score is " .. mulchoice_quiz:get_score() .. ".")
	--get user answer
	else
		if(#user_input<=3) then
			if(key=="1" or key=="2" or key=="3" or key=="4") then
				user_input = user_input .. key
			end
		end
	end


end

--Renders this instance of MultipleChoiceView and all its child views
function MultipleChoiceView:render(surface)
	if not self.listening_initiated then
		local callback = utils.partial(self.press)
		-- Example code snippet
		self:listen_to(
			event.remote_control,
			"button_release",
			callback
		)

		-- TODO initiate listening to the button group

		self.listening_initiated = true
	end

	if self:is_dirty() then
		surface:clear(color)
		if false then -- The user has answered a question, display result
			if self.num_quiz:answer(self.user_answer) then
				output = "Correct!"
			else
				output = "False :("
			end
			self.font:draw_over_surface(surface, output)
		else
			--Render a new multiple choice question
		end
	end
	-- Render all child views and copy changes to this view
	-- Render input component

	gfx.update()
	--If the user updated dirty flag will remain true to make sure the user can
	-- navigate to the next question
	self:dirty(false)
end

return MultipleChoiceView
