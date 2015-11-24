--- InputField class.
-- @classmod InputField
local utils = require("lib.utils")
local logger = require("lib.logger")
local class = require("lib.classy")
local View = require("lib.view.View")
local KeyboardComponent	=	require("components.KeyboardComponent")
local InputField = class("InputField", View)

--- Constructor for InputField
--@param color The color of InputField which is neither disabled nor selected
--@param color_selected The color for a selected InputField

function InputField:__init(name, position, highlighted)
	View.__init(self)
	self.highlighted_color = {r=255, g=200, b=195}
	self.highlighted = highlighted or false
  self.text = ""
  self.name = name
  self.position = position


  self.keyboard = KeyboardComponent()
	self.keyboard:set_active(false)
end

-- TODO, remove text_position
function InputField:get_text()
	return self.text
end

function InputField:is_highlighted()
	return self.highlighted
end

function InputField:set_highlighted(status)
	self.highlighted = status
end

function InputField:activate_keyboard(status)
	self.keyboard:set_active(status)
end

function InputField:is_active()
	return self.keyboard:is_active()
end

function InputField:render(surface)
	self:dirty(false)
  local input_field_title = sys.new_freetype({r=23, g=155, b=23}, 30, {x=self.position["x"],y=self.position["y"]-40}, utils.absolute_path("data/fonts/DroidSans.ttf"))
	if self.highlighted then
		surface:fill(self.highlighted_color, {width=500, height=100, x=self.position["x"], y=self.position["y"]})
	else
		surface:fill({r=234, g= 2, b=234}, {width=500, height=100, x=self.position["x"], y=self.position["y"]})
	end
  input_field_title:draw_over_surface(surface, self.name)

  local input_field_text = sys.new_freetype({r=23, g=155, b=23}, 40, {x=self.position["x"]+20,y=self.position["y"]+20}, utils.absolute_path("data/fonts/DroidSans.ttf"))


	-- TODO set mappings to RC
	if (self.keyboard:is_active()) then
		--keyboard:button_press(button)
		self.keyboard:render(surface)
	else
		logger:trace("regular bindings")
		--regular RC bindings
	end


  local done_callback = function()

    self.text = self.keyboard:get_string()
    --logger:trace("Current input: " .. current_input)
    input_field_text:draw_over_surface(surface, self.text)
    --render shit
    gfx.update()
  end

  self:listen_to(self.keyboard, "character_input", done_callback)
end


return InputField
