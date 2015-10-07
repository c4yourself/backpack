local event = require("lib.event")
local utils = require("lib.utils")
local quest = require("lib.quiz.Question")
local Button=require("lib.components.Button")
local multiple_quiz = {}


function multiple_quiz.render(surface)
   --event.remote_control:on("button_release" ,function(key)
   surface:fill({r=255,g=255,b=255})
		-- surface:clear({r=80,g=90,b=100})
		 --gfx:update()


         --Reset the surface
         local backgroundColor = {r=0, g=0, b=0}
         --screen:clear(backgroundColor)

         --create a green color xD and locations for buttons
         local buttonColor = {r=250, g=0, b=0}

         --create 4 buttons
         butt1=Button("quadrangle",100,100,500,300, surface, "6", "hej")
         butt1:show(100,150,200)
         butt2=Button("quadrangle", 100, 100, 700, 300, surface, "7", "tja")
         butt2:show(100, 150, 250)
         butt3=Button("quadrangle", 100, 100, 500, 600, surface, "8", "hej")
         butt3:show(100, 150, 250)
         butt4=Button("quadrangle", 100, 100, 700, 600, surface, "9", "hej")
         butt4:show(100, 150, 250)

         gfx:update()



end
return multiple_quiz
