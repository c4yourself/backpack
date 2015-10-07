local class=require("lib.classy")
local utils = require("lib.utils")
local event = require("lib.event")
local MultipleChoiceInterface=class("MultipleChoiceInterface")

function MultipleChoiceInterface:__init()
end
function MultipleChoiceInterface:render(hej)
	print("rendering Multiple Choice Interface")

	--Reset the surface
	local backgroundColor = {r=0, g=0, b=0}
	--screen:clear(backgroundColor)

	--create a green color xD and locations for buttons
	local buttonColor = {r=250, g=0, b=0}

	--create 4 buttons
	--[[butt1=Button("quadrangle",100,100,500,300, "view", "1")
	butt1:show(100,150,200)
	butt2=Button("quadrangle", 100, 100, 700, 300, "view", "2")
	butt2:show(100, 150, 250)
	butt3=Button("quadrangle", 100, 100, 500, 600, "view", "3")
	butt3:show(100, 150, 250)
	butt4=Button("quadrangle", 100, 100, 700, 600, "view", "4")
	butt4:show(100, 150, 250)]]




end
