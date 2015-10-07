--- Question generator module. Module used for generating MultipleChoice questions
-- @module multiplequestiongenerator

local MultipleChoiceQuestion = require("lib.quiz.MultipleChoiceQuestion")
local Quiz = require("lib.quiz.Quiz")
local utils = require("lib.utils")
local event = require("lib.event")

-- Generates a global numerical quiz intance
mulchoice_quiz = Quiz()
mulchoice_quiz:generate_multiplechoice_quiz("image_path",10)
--mulchoice_quiz:get_choices()
local multiplechoice_quiz={}
local user_input=""
local answer={}
local end_flag=0
--- Renders a surface for a MultipleChoice quiz
function multiplechoice_quiz.render(surface)
	surface:clear(color)

	event.remote_control:off("button_release")
	local buttonColor = {r=0, g=128, b=225}
	local textColor = {r=0, g=0, b=0}
	local choiceButton1 = sys.new_freetype(textColor, 30, {x=100,y=400}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local choiceButton2 = sys.new_freetype(textColor, 30, {x=350,y=400}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local choiceButton3 = sys.new_freetype(textColor, 30, {x=600,y=400}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local choiceButton4 = sys.new_freetype(textColor, 30, {x=850,y=400}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	local correct_answer_number=0
	font = sys.new_freetype(
		{r = 255, g = 255, b = 255, a = 255},
		32,
		{x = 100, y = 300},
		utils.absolute_path("data/fonts/DroidSans.ttf"))
		i=1
		font:draw_over_surface(screen, mulchoice_quiz.questions[i].question)
		surface:fill(buttonColor, {width=200, height=60, x=100, y=400})
		choiceButton1:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[1])
		surface:fill(buttonColor, {width=200, height=60, x=350, y=400})
		choiceButton2:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[2])
		surface:fill(buttonColor, {width=200, height=60, x=600, y=400})
		choiceButton3:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[3])
		surface:fill(buttonColor, {width=200, height=60, x=850, y=400})
		choiceButton4:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[4])
		--print (mulchoice_quiz.questions[i].question)
			event.remote_control:on("button_release", function(key)
				if key=="right" then
					for j=1,#user_input,1 do
						answer[j]=tonumber(string.sub(user_input,j,j))
					end
					print(mulchoice_quiz.questions[i]:is_correct(answer))
					if mulchoice_quiz.questions[i]:is_correct(answer)==true then
						correct_answer_number=correct_answer_number+1
					end
					surface:clear(color)
					answer={}
					user_input=""

					if end_flag==1 then
						surface:clear(color)
						font:draw_over_surface(screen, "You answered " .. correct_answer_number .. " questions correctly")
					end
					if i<10 then
						i=i+1
						print (mulchoice_quiz.questions[i].question)
						font:draw_over_surface(screen, mulchoice_quiz.questions[i].question)
						surface:fill(buttonColor, {width=200, height=60, x=100, y=400})
						choiceButton1:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[1])
						surface:fill(buttonColor, {width=200, height=60, x=350, y=400})
						choiceButton2:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[2])
						surface:fill(buttonColor, {width=200, height=60, x=600, y=400})
						choiceButton3:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[3])
						surface:fill(buttonColor, {width=200, height=60, x=850, y=400})
						choiceButton4:draw_over_surface(surface, mulchoice_quiz.questions[i].Choices[4])
						if i==10 then
							end_flag=1
						end
					end
				else
					if(#user_input<=3) then
						if(key=="1" or key=="2" or key=="3" or key=="4") then
					user_input = user_input .. key
				end
				end
					--print(user_input)
				end
				gfx.update()
			end)
end

return multiplechoice_quiz
