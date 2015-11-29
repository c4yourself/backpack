--- InputField class.
-- @classmod InputField
local utils = require("lib.utils")
local logger = require("lib.logger")
local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local View = require("lib.view.View")
local InputField = class("InputField", View)

--- Constructor for InputField
--@param color The color of InputField which is neither disabled nor selected
--@param color_selected The color for a selected InputField

function InputField:__init(name, position, highlighted)
	View.__init(self)
	self.highlighted_color = {r=250, g=169, b=0}
	self.normal_color = {r=255, g=255, b=255}
	self.font_header = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.font_text = Font("data/fonts/DroidSans.ttf", 40, Color(0, 0, 0, 255))
	self.highlighted = highlighted or false
  self.text = ""
  self.name = name
  self.position = position
	self.private = false
end

-- TODO, remove text_position
function InputField:get_text()
	return self.text
end

function InputField:set_text(text)
	self.text = text
end

function InputField:is_highlighted()
	return self.highlighted
end

function InputField:set_highlighted(status)
	self.highlighted = status
end

function InputField:set_private(status)
	self.private = status
end

function InputField:render(surface)
	self:dirty(false)
	--= sys.new_freetype({r=255, g=255, b=255}, 30, {x=self.position["x"],y=self.position["y"]-40}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	if self.highlighted then
		surface:fill(self.highlighted_color, {width=500, height=100, x=self.position["x"], y=self.position["y"]})
	else
		surface:fill(self.normal_color, {width=500, height=100, x=self.position["x"], y=self.position["y"]})
	end
  --input_field_title:draw_over_surface(surface, self.name)
  self.font_header:draw(surface, {x=self.position["x"],y=self.position["y"]-40}, self.name)

  --local input_field_text = sys.new_freetype({r=23, g=155, b=23}, 40, {x=self.position["x"]+20,y=self.position["y"]+20}, utils.absolute_path("data/fonts/DroidSans.ttf"))
  --input_field_text:draw_over_surface(surface, self.text)
	if not self.private then
		self.font_text:draw(surface, {x=self.position["x"]+20,y=self.position["y"]+20}, self.text)
	else
		password_dummie = ""
		for i=1,#self.text do
			password_dummie = password_dummie .. "-"
		end
		self.font_text:draw(surface, {x=self.position["x"]+20,y=self.position["y"]+20}, password_dummie)
		logger:trace(self.text)
	end
  gfx.update()
end


return InputField
