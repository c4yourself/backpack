local event = require("lib.event")
local utils = require("lib.utils")
local quest = require("lib.quiz.Question")
local multiple_quiz = {}


function multiple_quiz.render(surface)
   --event.remote_control:on("button_release" ,function(key)
   surface:fill({r=255,g=255,b=255})
		-- surface:clear({r=80,g=90,b=100})
		 gfx:update()



end
return multiple_quiz
