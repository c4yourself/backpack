local class=require("lib.classy")
local Button=class("Button")
local event = require("lib.event")

Button.diff_button_map = {"quadrangle","radio"}
Button.type = ""
Button.text = ""
indexx=0;
function Button:__init(type,length,width,xoffset,yoffset, view, keyInput)

event.remote_control:on("button_release", function(key)
     if key==keyInput then
         self:show(0,200,0)
     else
         self:show(100, 50, 50)
   end
 end)


    self.type=type
	if self.type==self.diff_button_map[1] then
      self.width=width
	   self.height=length
	   self.x=xoffset
	   self.y=yoffset

   elseif self.diff_button_map[2]==type then

  end


end

function Button:setText()

end

function Button:show_Image(path)
    gfx.loadImage(path)
end


function Button:show(r,g,b)
	if self.type==self.diff_button_map[1] then
    screen:clear({r=r,g=g,b=b},{width=self.width,height=self.height,x=self.x,y=self.y})
elseif self.type==self.diff_button_map[2] then

  end
   gfx.update()

end



return Button

--[[local width = math.floor(screen:get_width() / #rainbow)
for i, color in ipairs(rainbow) do
	screen:clear(color, {width = width, height = 100, x = 20 * (i-1)})
end]]
