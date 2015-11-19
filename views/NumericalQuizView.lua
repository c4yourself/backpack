--- Base class for NumericQuizView
-- @classmod NumericQuizView
local NumericalInputComponent = require("components.NumericalInputComponent")
local class = require("lib.classy")
local View = require("lib.view.View")
local NumericQuizView = class("NumericQuizView", View)
local Surface = require("emulator.surface")
local utils = require("lib.utils")
local event = require("lib.event")
local view = require("lib.view")
local Quiz = require("lib.quiz.Quiz")
local NumericQuestion = require("lib.quiz.NumericQuestion")
local SubSurface = require("lib.view.SubSurface")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")

--- Constructor for NumericQuizView
function NumericQuizView:__init()
	View.__init(self)
	event.remote_control:off("button_release") -- TODO remove this once the ViewManager is fully implemented

	-- Flags
	--Flags to determine whether a quiz or a question is answered
	self.answer_flag = false
	self.quiz_flag = false
	self.listening_initiated = false
	self.input_area_defined = false
	--Components
	self.button_grid = button_grid(remote_control)

	--Instanciate a numerical input component and make the quiz listen for changes
	self.views.num_input_comp = NumericalInputComponent()
	self.input_surface = Surface(300,100)

	-- Logic
	-- Associate a quiz instance with the View
	self.num_quiz = Quiz()
	self.num_quiz:generate_numerical_quiz("NOVICE", 5+1, "image_path")
	-- User input
	self.user_answer = ""

	-- Graphics
	self.font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))

	self.question_area_color = Color(255,0,0,255)
	self.question_area_font = Font("data/fonts/DroidSans.ttf", 32, Color(255,255,255,255))
	-- Listeners and callbacks
	self:listen_to(
		event.remote_control,
		"button_release",
		utils.partial(self.press, self)
	)
end

--Responds to a button press when the View is active (i.e. current View for the
-- global @{ViewManager} instance)
function NumericQuizView:press(key)
	if key == "right" then
		-- Navigate to the next question if the user already submitted an answer
		if self.answer_flag then
			self.answer_flag = false
			self:dirty(false)
			self:dirty(true) -- To make sure dirty event is triggered
		end
	elseif key == "back" then
		self:trigger("exit")
	end
end

--Renders a NumericQuizView and all its child views
function NumericQuizView:render(surface)
	local surface_width = surface:get_width()
	local surface_height = surface:get_height()
	if self:is_dirty() then
		surface:clear(color)
		--Question area
		local x = math.ceil(surface:get_width() * 0.2)
		local y = math.ceil(surface:get_height() * 0.2)
		local question_area_width = surface_width - 2 * x
		local question_area_height = math.ceil(0.3*surface_height)
		self.question_area = SubSurface(surface, {x = x, y = y,
			height = question_area_height,
			width = question_area_width})
		self.question_area:clear(self.question_area_color)
		--Determine what should be shown on screen
		if self.answer_flag then
			-- The user has answered a question
			if self.num_quiz:answer(self.user_answer) then
				output = "Correct!"
			else
				output = "False. You answered " .. tostring(self.user_answer) .. " and" .. "\n" .. "the correct answer was " .. tostring(self.num_quiz.questions[self.num_quiz.current_question].correct_answer) .. "."
			end
			self.question_area_font:draw(self.question_area, {x = 0, y = 0, height = question_area_height, width = question_area_width}, output, "center", "middle")
		else
			-- Show a new question if there is one, otherwise show final result
			self.answer_flag = false
			local question = self.num_quiz:get_question()
			if question ~= nil then
				local question = self.num_quiz:get_question()
				local question_text = "What is the answer to: " .. question .. "?"
				self.question_area_font:draw(self.question_area, {x = 0, y = 0, height = question_area_height, width = question_area_width}, question_text, "center", "middle")
			else
				-- The user has finished the quiz
				self.views.num_input_comp:blur()
				self.quiz_flag = true
				local output = "You answered " .. tostring(self.num_quiz.correct_answers)
				.. " questions correctly."
				self.question_area_font:draw(self.question_area, {x = 0, y = 0, height = question_area_height, width = question_area_width}, output, "center", "middle")
			end
		end
	end
	-- Render all child views and copy changes to this view
	-- Input component
	if not self.input_area_defined then
		local input_x = math.ceil(surface:get_width() * 0.4)
		local input_y = math.ceil(surface:get_height() * 0.6)
		self.input_area = SubSurface(surface, {x = input_x, y = input_y,
			height = math.ceil(0.2 * surface_height),
			width = math.ceil(0.2 * surface_width)})
	end
	self.views.num_input_comp:render(self.input_area)

	if not self.listening_initiated then
		local change_callback = utils.partial(self.views.num_input_comp.render, self.views.num_input_comp, self.input_area)
		self:listen_to(
			self.views.num_input_comp,
			"change",
			change_callback
		)

		self:listen_to(
			self.views.num_input_comp,
			"submit",
			utils.partial(self.show_answer, self)
		)
		self.views.num_input_comp:focus() --TODO Move this to its proper place
		self.listening_initiated = true
	end

	--surface:copyfrom(self.input_surface)

	gfx.update()
	self:dirty(false)
end

-- Displays the correct answer and whether the user chose the correct one.
function NumericQuizView:show_answer()
	if self.views.num_input_comp:get_text() ~= "" then
		self.answer_flag = true
		self.user_answer = tonumber(self.views.num_input_comp:get_text())
		self.views.num_input_comp:set_text(nil)
		self:dirty(false)
		self:dirty(true)
	end
end

return NumericQuizView
