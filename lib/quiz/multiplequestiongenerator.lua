
local multiplequestiongenerator = {}
local MultipleChoiceQuestion = require("lib.quiz.MultipleChoiceQuestion")
questions={"Which of following countries in Europe?",
			"Which of following countries in Africa?",
			"Which of following countries in North America?",
			"Which of following countries in South America?",
			"Which of following countries in Asia?",
			"Which of following cities in Europe?",
			"Which of following cities in Africa?",
			"Which of following cities in North America?",
			"Which of following cities in South America?",
			"Which of following cities in Asia?",}
choices={{"Italy","England","Sweden","South Africa"},
		 {"Sweden","France","Mexico","South Africa"},
		 {"Sweden","America","Canada","Korea"},
		 {"Sweden","Japan","Brazil","America"},
		 {"Sweden","Japan","Korea","America"},
		 {"Chaigo","Pairs","Stockholm","New York"},
		 {"Stockholm","Pairs","Cairo","New York"},
		 {"Stockholm","Pairs","Shanghai","New York"},
		 {"Stockholm","Pairs","Shanghai","Lima"},
		 {"Stockholm","Pairs","Roma","Hong Kong"}
		 }
correct_answers={{1,2,3},
				 {4},
				 {2,3},
			 	 {3},
			 	 {2,3},
			 	 {2,3},
			 	 {3},
				 {4},
			 	 {4},
			 	 {4}}
function multiplequestiongenerator.generate(image_path,count)
	local question=MultipleChoiceQuestion(image_path,questions[count],correct_answers[count],choices[count])
	--question:set_choices(choices[count])
	--print(choices[count][1])
	return question
end
return multiplequestiongenerator
