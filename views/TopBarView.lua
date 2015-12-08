local class = require("lib.classy")
local View = require("lib.view.View")
local Font = require("lib.draw.Font")
local Color = require("lib.draw.Color")
local Rectangle = require("lib.draw.Rectangle")
local logger = require("lib.logger")

local TopBarView = class("TopBarView", View)

--- Constructor
-- @param remote_control, email, password
function TopBarView:__init(profile)
	View.__init(self)

	self.profile = profile

	self.background_color = Color(0, 0, 0, 255)
	self.font_color = Color(255, 255, 255, 255)
	self.border_color = Color(65, 70, 72, 255)

	self.coin_image = gfx.loadpng("data/images/coinIcon.png")
	self.coin_image:premultiply()
	self.font = Font("data/fonts/DroidSans.ttf", 20, self.font_color)
end

function TopBarView:destroy()
	View.destroy(self)
	self.coin_image:destroy()
end

function TopBarView:render(surface)
	local width = surface:get_width()
	local height = surface:get_height() - 5

	local city = self.profile:get_city()

	-- Background
	surface:clear(self.background_color:to_table())
	surface:clear(
		self.border_color:to_table(),
		Rectangle(0, height, surface:get_width(), 5))

	-- Profile name
	self.font:draw(
		surface,
		{x = 40, y = 0, height = height},
		self.profile.name,
		nil,
		"middle")

	local level, experience, limit = self.profile:get_level()

	-- Level
	self.font:draw(
		surface,
		{x = 200, y = 0, height = height},
		"Level " .. level,
		nil,
		"middle")

	-- Status bar
	local experience_offest_x = 285
	local experience_offest_y = height / 2 - 25 / 2
	local experience_width = math.ceil(146 * experience / limit)

	surface:clear(
		self.font_color:to_table(),
		{
			x = experience_offest_x,
			y = experience_offest_y,
			width = 150,
			height = 25,
		})
	surface:clear(
		self.background_color:to_table(),
		{
			x = experience_offest_x + 2,
			y = experience_offest_y + 2,
			width = 146,
			height = 21,
		})
	if experience_width > 0 then
		surface:fill(
			self.font_color:to_table(),
			{
				x = experience_offest_x + 2,
				y = experience_offest_y + 2,
				width = experience_width,
				height = 21,
			})
	end

	-- Experience counter
	self.font:draw(
		surface,
		{x = 445, y = 0, height = height},
		experience .. "/" .. limit,
		nil,
		"middle")

	-- City name
	self.font:draw(
		surface,
		{x = width / 2, y = 0, height = height},
		city.name,
		nil,
		"middle")

	-- Coins
	local coin_offset_x = width - 200
	local coin_offset_y = math.floor(height / 2 - 25 / 2)
	surface:copyfrom(
		self.coin_image,
		nil,
		{x = coin_offset_x, y = coin_offset_y, width = 25, height = 25},
		true)
	self.font:draw(
		surface,
		{x = coin_offset_x + 35, y = 0, height = height},
		city.country:format_balance(self.profile.balance),
		nil,
		"middle")
end

return TopBarView
