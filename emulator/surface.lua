--- An area (pixmap) in graphics memory.
--
-- Part of Zenterio Lua API.  Color format is 32-bit RGBA. Surfaces are
-- constructed using @{emulator.gfx:new_surface|gfx:new_surface}.
--
-- @classmod emulator.surface
-- @alias surface

local class = require("lib.classy")
local Color = require("lib.color.Color")
local logger = require("lib.logger")

local surface = class("surface")

--- Fills the surface with the given color.
--
-- Fills the surface with a solid color, using hardware acceleration on set-top
-- box. Surface transparency is replaced by the transparency value of color.
--
-- @param color Fill color. Defaults to {0, 0, 0, 0}, that is black and
--              completely transparent.
-- @param rectangle Area to fill with color. Defaults to whole surface. Parts
--                  outside the rectangle are not affected.
-- @zenterio
function surface:clear(color, rectangle)
	local color = Color.from_table(color)
	local rect = self:_get_rectangle(rectangle)

	-- Loop through every pixel and blend its color
	for x = rect.x, rect.x + rect.width - 1 do
		for y = rect.y, rect.y + rect.height - 1 do
			self.image_data:setPixel(x, y, color:to_values())
		end
	end
end

--- Blends the surface with a solid color, weighing alpha values (SRCOVER).
--
-- Uses hardware acceleration on set-top box.
--
-- @param color Blend color.
-- @param rectangle Area to blend with color. Defaults to whole surface. Parts
--                  outside the rectangle are not affected.
-- @see emulator.surface:clear
-- @zenterio
function surface:fill(color, rectangle)
	local color = Color.from_table(color)
	local rect = self:_get_rectangle(rectangle)

	-- Loop through every pixel and blend its color
	for x = rect.x, rect.x + rect.width - 1 do
		for y = rect.y, rect.y + rect.height - 1 do
			local current_color = Color(self.image_data:getPixel(x, y))
			--print(current_color:to_html() .. current_color:blend(color):to_html())
			--sys.exit()
			self.image_data:setPixel(x, y, current_color:blend(color):to_values())
		end
	end
end

--- Copy pixels from one surface to another.
--
-- Uses hardware acceleration on set-top box.
--
-- Scaling is done if dest_rectangle is of different size than src_rectangle.
-- Areas outside of source or destination surfaces will be cropped.
--
-- @param src_surface Surface to copy pixels from.
-- @param src_rectangle Source rectangle on surface to copy from. Defaults to
--                      entire surface.
-- @param dest_rectangle Destination rectangle on this surface to copy to.
--                       Defaults src_rectangle's width and height at position
--                       {x = 0, y = 0}.
-- @param blend_option true if alpha blending should occur, otherwise false.
-- @zenterio
function surface:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)

	--Defaults to entire surface
	local source_rectangle = {}

	--if src_rectangle is nil, defaul to entire source surface
	if src_rectangle == nil then
		source_rectangle.x = 0
		source_rectangle.y = 0
		source_rectangle.w = src_surface.image_data:getWidth()
		source_rectangle.h = src_surface.image_data:getHeight()
	else
		source_rectangle.x = src_rectangle.x or 0
		source_rectangle.y = src_rectangle.y or 0
		source_rectangle.w = src_rectangle.w or src_surface.image_data:getWidth()
		source_rectangle.h = src_rectangle.h or src_surface.image_data:getHeight()
	end

	local destination_rectangle = {}

	--if src_rectangle is nil, defaul to enture source surface
	if dest_rectangle == nil then
		destination_rectangle.x = 0
		destination_rectangle.y = 0
		destination_rectangle.w = src_surface.image_data:getWidth()
		destination_rectangle.h = src_surface.image_data:getHeight()
	else
		destination_rectangle.x = dest_rectangle.x or 0
		destination_rectangle.y = dest_rectangle.y or 0
		destination_rectangle.w = dest_rectangle.w or src_surface.image_data:getWidth()
		destination_rectangle.h = dest_rectangle.h or src_surface.image_data:getHeight()
	end


	local scale_x = destination_rectangle.w / source_rectangle.w
	local scale_y = destination_rectangle.h / source_rectangle.h

	local canvas = love.graphics.newCanvas(
		self.image_data:getWidth(), self.image_data:getHeight())
	love.graphics.setCanvas(canvas)

	love.graphics.draw(love.graphics.newImage(self.image_data))
	love.graphics.draw(
		love.graphics.newImage(src_surface.image_data),
		destination_rectangle.x,
		destination_rectangle.y,
		0,
		scale_x,
		scale_y)

	love.graphics.setCanvas()

	self.image_data = canvas:getImageData()
	canvas = {}
end


--- Get surface width.
-- @return Width of surface in pixels
-- @zenterio
function surface:get_width()
	return self.image_data:getWidth()
end

--- Get surface height.
-- @return Height of surface in pixels
-- @zenterio
function surface:get_height()
	return self.image_data:getHeight()
end

--- Get color of pixel.
--
-- Useful for testing. Not optimized for speed
--
-- @param x X position (starting at 0)
-- @param y Y position (starting at 0)
-- @return red, green, blue, alpha
-- @zenterio
function surface:get_pixel(x, y)
	r, g, b, a = self.image_data:getPixel( x, y )
	return r, g, b, a
end

--- Set color of pixel.
--
-- Useful for testing. Not optimized for speed
--
-- @param x X position (starting at 0)
-- @param y Y position (starting at 0)
-- @param color Color of pixel
-- @zenterio
function surface:set_pixel(x, y, color)
	self.image_data:setPixel(x, y, color.r, color.g, color.b, color.a)
end

--- Premultiply surface.
--
-- Changes the surface pixel components by multiplying the alpha channel into
-- the color channels. This prepares some images for blending with transparency.
--
-- Currently not implemented in emulator!
-- @zenterio
function surface:premultiply()
	-- TODO: Implement this
end

--- Free this surface from memory.
--
-- Frees the graphics memory used by this surface. The same is eventually done
-- automatically by Lua garbage collection for unreferenced surfaces but doing
-- it by hand guarantees the memory is returned at once.
--
-- The surface can not be used again after this operation.
-- @zenterio
function surface:destroy()
	self.image_data = nil
end

--- Set alpha channel for entire surface.
-- @param alpha Alpha value between 0-255 (0 is transparent, 255 is opaque)
function surface:set_alpha(alpha)
	for i = 0, self.image_data:getWidth()-1 do
		for j = 0, self.image_data:getHeight()-1 do
			r, g, b, a = self.image_data:getPixel(i, j)
			self.image_data:setPixel(i, j, r, g, b, alpha)
		end
	end
end

-- Functions below this point are not part of Zenterio's API

--- Constructor for new surfaces.
-- Not part of Zenterio's Lua API!
--
-- @param width Width of surface in pixels
-- @param height Height of surface in pixels
--
-- @local
function surface:__init(width, height)
	if width == nil and height == nil then
		logger.trace("New empty surface")
		self.image_data = nil
	else
		logger.trace("New surface", {width = width, height = height})
		self.image_data = love.image.newImageData(width, height)
	end
end

--- Load image from given path.
-- Not part of Zenterio's Lua API!
-- @param path Path to the image
-- @local
function surface:loadImage(path)
	logger.trace(path)
	local tempFile = io.open(path,"rb")
	if tempFile then
		local imageStream = tempFile:read("*a")
		tempFile:close()

		local fileData, err = love.filesystem.newFileData(imageStream, path)
		self.image_data = love.image.newImageData(fileData)
	else
		logger.error("Error loading image - '"..path.."'")
	end

end

--- Emulator function to write text on surface.
--
-- Not part of Zenterio's Lua API!
--
-- Used by @{emulator.freetype:draw_over_surface}
--
-- @param text Text to draw
-- @param fontColor Color of text
-- @param drawingStartPoint Left upper corner a start point to a drawing text
--
-- @local
function surface:writeOver(text, fontColor, drawingStartPoint)
	local canvas = love.graphics.newCanvas(
		self.image_data:getWidth(), self.image_data:getHeight())
	love.graphics.setCanvas(canvas)

	love.graphics.draw(love.graphics.newImage(self.image_data))

	local r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(fontColor.r, fontColor.g, fontColor.b, fontColor.a)
	love.graphics.print(text, drawingStartPoint.x, drawingStartPoint.y)
	love.graphics.setColor(r, g, b, a)

	love.graphics.setCanvas()

	self.image_data = canvas:getImageData()
	canvas = {}
end

--- Emulator function to draw this surface on screen.
-- Not part of Zenterio's Lua API!
-- @local
function surface:draw()
	image = love.graphics.newImage(self.image_data)
	function love.draw()
		love.graphics.draw(image)
	end
end

--- Convert a given rectangle to canonical form.
-- @return Table with rectangle x, y, width and height values
-- @local
function surface:_get_rectangle(rectangle)
	local rect = {
		x = 0,
		y = 0,
		width = self:get_width(),
		height = self:get_height()
	}

	if rectangle == nil then
		return rect
	end

	rect.x = rectangle.x or rect.x
	rect.y = rectangle.y or rect.y
	rect.width = (rectangle.width or rectangle.w or rect.width)
	rect.height = (rectangle.height or rectangle.h or rect.height)

	local end_x = rect.x + rect.width - 1
	local end_y = rect.y + rect.height - 1

	-- Throw error when trying to draw outside of screen
	if end_x >= self:get_width() or end_y >= self:get_height() then
		logger.error(string.format(
			"Rectange start is %dx%d, end is %dx%d. Max is %dx%d",
			rect.x, rect.y,
			end_x, end_y,
			self:get_width() - 1, self:get_height() - 1))
		error("Rectangle is out of bounds")
	end

	return rect
end

return surface
