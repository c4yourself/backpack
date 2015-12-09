--- BinaryButton class.
-- @classmod BinaryButton
local utils = require("lib.utils")
local logger = require("lib.logger")
local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Font = require("lib.draw.Font")
local View = require("lib.view.View")
local BinaryButton = class("BinaryButton", View)

--- Constructor for BinaryButton
--@param color The color of BinaryButton which is neither disabled nor selected
--@param color_selected The color for a selected BinaryButton

function BinaryButton:__init(name, value1, value2, position, highlighted)
	View.__init(self)
	self.highlighted_color = {r=250, g=169, b=0}
	self.normal_color = {r=250, g=105, b=0}
	self.font_header = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.font_text = Font("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	self.highlighted = highlighted or false
  self.isValue2 = false
  self.value1 = value1
  self.value2 = value2
  self.text = self.value1
  self.name = name
  self.position = position
end

function BinaryButton:get_value()
	return tostring(self.text)
end

function BinaryButton:swap_value()
  if self.isValue2 then
    self.text = self.value1
    self.isValue2 = false
  else
    self.text = self.value2
    self.isValue2 = true
  end
end

function BinaryButton:is_highlighted()
	return self.highlighted
end

function BinaryButton:select(status)
	self.highlighted = status
end

function BinaryButton:render(surface)
	self:dirty(false)
	if self.highlighted then
		surface:fill(self.highlighted_color, {width=200, height=70, x=self.position["x"], y=self.position["y"]})
	else
		surface:fill(self.normal_color, {width=200, height=70, x=self.position["x"], y=self.position["y"]})
	end
  self.font_header:draw(surface, {x=self.position["x"],y=self.position["y"]-40}, self.name)

	self.font_text:draw(surface, {x=self.position["x"]+40,y=self.position["y"]+10}, self.text)
  gfx.update()
end


return BinaryButton
