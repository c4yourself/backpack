--- An area (pixmap) in graphics memory.
--
-- Part of Zenterio Lua API.  Color format is 32-bit RGBA. Surfaces are
-- constructed using @{emulator.gfx.new_surface|gfx.new_surface}.
--
-- @classmod emulator.surface
-- @alias surface

local class = require("lib.classy")
local Color = require("lib.draw.Color")
local Rectangle = require("lib.draw.Rectangle")
local logger = require("lib.logger")

local surface = class("surface")

surface.log = false

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

	local canvas = love.graphics.newCanvas(
		self.image_data:getWidth(), self.image_data:getHeight())

	canvas:renderTo(function()
		love.graphics.setBlendMode("premultiplied")
		love.graphics.draw(love.graphics.newImage(self.image_data))

		-- Save old color to restore it later
		local fr, fg, fb, fa = love.graphics.getColor()
		local br, bg, bb, ba = love.graphics.getColor()

		love.graphics.setColor(color:to_values())
		love.graphics.setBackgroundColor(0, 0, 0, 0)

		love.graphics.setScissor(rect.x, rect.y, rect.width, rect.height)
		love.graphics.clear()
		love.graphics.setScissor()

		love.graphics.rectangle(
			"fill", rect.x, rect.y, rect.width, rect.height)

		-- Restore previous color
		love.graphics.setColor(fr, fg, fb, fa)
		love.graphics.setBackgroundColor(br, bg, bb, ba)

		love.graphics.setBlendMode("alpha")
	end)

	self.image_data = canvas:getImageData()
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

	local canvas = love.graphics.newCanvas(
		self.image_data:getWidth(), self.image_data:getHeight())

	canvas:renderTo(function()
		love.graphics.setBlendMode("premultiplied")
		love.graphics.draw(love.graphics.newImage(self.image_data))
		love.graphics.setBlendMode("alpha")

		-- Save old color to restore it later
		local r, g, b, a = love.graphics.getColor()

		love.graphics.setColor(color:to_values())
		love.graphics.rectangle(
			"fill", rect.x, rect.y, rect.width, rect.height)

		-- Restore previous color
		love.graphics.setColor(r, g, b, a)
	end)

	self.image_data = canvas:getImageData()
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
--                      entire surface. Omitted area will be cropped.
-- @param dest_rectangle Destination rectangle on this surface to copy to.
--                       Defaults src_rectangle's width and height at position
--                       {x = 0, y = 0}.
-- @param blend_option true if alpha blending should occur, otherwise false.
--                     Default is false.
-- @zenterio
function surface:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)
	local source_rectangle = src_surface:_get_rectangle(src_rectangle)
	local destination_rectangle = self:_get_rectangle(dest_rectangle, {
		width = source_rectangle.width, height = source_rectangle.height
	})

	local scale_x = destination_rectangle.width / source_rectangle.width
	local scale_y = destination_rectangle.height / source_rectangle.height

	local canvas = love.graphics.newCanvas(
		self.image_data:getWidth(), self.image_data:getHeight())

	-- Calculate Quad of source surface to draw (normally entire surface)
	local cropping = love.graphics.newQuad(
		source_rectangle.x,
		source_rectangle.y,
		source_rectangle.width,
		source_rectangle.height,
		src_surface:get_width(),
		src_surface:get_height())

	-- Determine draw function to use. Compatibility with Love 0.8
	local drawq = love.graphics.draw
	if love.graphics.drawq then
		drawq = love.graphics.drawq
	end

	canvas:renderTo(function()
		-- Set blend mode to premultiplied to make alpha transparency work
		-- correctly. If left to alpha transparent pixels will darken for every
		-- call to :copyfrom.
		love.graphics.setBlendMode("premultiplied")
		love.graphics.draw(love.graphics.newImage(self.image_data))

		if blend_option then
			love.graphics.setBlendMode("alpha")
		else
			-- Save old color to restore it later
			local br, bg, bb, ba = love.graphics.getColor()
			love.graphics.setBackgroundColor(0, 0, 0, 0)

			-- Clear pixels where target will be drawn
			love.graphics.setScissor(
				destination_rectangle.x,
				destination_rectangle.y,
				destination_rectangle.width,
				destination_rectangle.height)
			love.graphics.clear()
			love.graphics.setScissor()

			-- Restore previous color
			love.graphics.setBackgroundColor(br, bg, bb, ba)
		end

		drawq(
			love.graphics.newImage(src_surface.image_data),
			cropping,
			destination_rectangle.x,
			destination_rectangle.y,
			0,
			scale_x,
			scale_y)

		love.graphics.setBlendMode("alpha")
	end)

	self.image_data = canvas:getImageData()
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
-- @return `{r = red, g = green, b = blue, b = alpha}`
-- @zenterio
function surface:get_pixel(x, y)
	local r, g, b, a = self.image_data:getPixel(x, y)
	return {r = r, g = g, b = b, a = a}
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
	local color = Color.from_table(color)
	self.image_data:setPixel(x, y, color:to_values())
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
	if surface.log then
		logger.trace("Surface destroyed")
	end

	if self.image_data then
		gfx._free_surface(self)
	else
		logger.warn(
			"Surface destroyed more than once. This is a programming error " ..
			"perhaps.")
	end
	self.image_data = nil
end

--- Set alpha channel for entire surface.
-- @param alpha Alpha value between 0-255 (0 is transparent, 255 is opaque)
function surface:set_alpha(alpha)
	for x = 0, self.image_data:getWidth() - 1 do
		for y = 0, self.image_data:getHeight() - 1 do
			local r, g, b, a = self.image_data:getPixel(x, y)
			self.image_data:setPixel(x, y, r, g, b, alpha)
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
		-- Used when working with images
		self.image_data = nil
	else
		logger.trace(string.format("New surface %dx%d", width, height))
		self.image_data = love.image.newImageData(width, height)
	end
end

--- Load image from given path.
-- Not part of Zenterio's Lua API!
-- @param path Path to the image
-- @local
function surface:_load_image(path)
	if surface.log then
		logger.trace("New image surface", path)
	end

	if not love.filesystem.isFile(path) then
		error("No such image: " .. tostring(path))
	end

	local tempFile = io.open(path,"rb")
	if tempFile then
		local imageStream = tempFile:read("*a")
		tempFile:close()

		local fileData, err = love.filesystem.newFileData(imageStream, path)
		self.image_data = love.image.newImageData(fileData)
	else
		logger.error("Error loading image ", path)
	end
end

--- Emulator function to write text on surface.
--
-- Not part of Zenterio's Lua API!
--
-- Used by @{emulator.freetype:draw_over_surface}
--
-- @param freetype Freetype instance to use
-- @param text Text to write
--
-- @local
function surface:_write_text(freetype, text)
	local canvas = love.graphics.newCanvas(
		self.image_data:getWidth(), self.image_data:getHeight())

	canvas:renderTo(function()
		love.graphics.draw(love.graphics.newImage(self.image_data))

		-- Save old color to restore it later
		local r, g, b, a = love.graphics.getColor()

		love.graphics.setColor(freetype.color:to_values())

		love.graphics.setNewFont(freetype.path, freetype.size)
		love.graphics.print(text, freetype.position.x, freetype.position.y)

		-- Restore previous color
		love.graphics.setColor(r, g, b, a)
	end)

	self.image_data = canvas:getImageData()
end

--- Convert a given rectangle to canonical form.
-- @return Table with rectangle x, y, width and height values
-- @local
function surface:_get_rectangle(rectangle, defaults)
	if defaults == nil then
		defaults = {
			width = self:get_width(),
			height = self:get_height()
		}
	end

	local rect = Rectangle.from_table(rectangle, {
		width = defaults.width or defaults.w,
		height = defaults.height or defaults.h
	})

	local surface_rect = Rectangle.from_surface(self)

	-- Throw error when trying to draw outside of screen
	if not surface_rect:contains(rect) then
		logger.error(string.format(
			"Rectange start is %dx%d, end is %dx%d. Max is %dx%d",
			rect:get_start(),
			rect:get_end(),
			surface_rect:get_end()))
		error("Rectangle is out of bounds")
	end

	return rect:to_table()
end

return surface
