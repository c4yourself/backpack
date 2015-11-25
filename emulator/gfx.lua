--- Graphics module.
--
-- Part of Zenterio Lua API.
--
-- @module emulator.gfx
-- @alias gfx

local class = require("lib.classy")
local surface = require("emulator.surface")

local gfx = class("gfx")

--- New Surface
--
-- Creates and returns a new 32-bit RGBA graphics @{emulator.surface|surface} of
-- chosen dimensions. The surface pixels are not initialized;
-- @{emulator.surface:clear|surface:clear} or
-- @{emulator.surface:copyfrom|surface:copyfrom} should be used for this.
--
-- @param width Surface width in pixels. Must be positive integer 1-10000.
-- @param height Surface height in pixels. Must be positive integer 1-10000.
--
-- @raise Error if enough graphics memory cannot be allocated.
-- @return New instance of surface
-- @zenterio
function gfx.new_surface(width, height)
	--local image_data = surface()
	--image_data:change_size(width, height)
	local image_data = surface(width, height)
	return image_data
end

--- Load PNG as a new surface
--
-- Loads the PNG image at <path> into a new surface that is returned. The image
-- is always translated to 32-bit RGBA. Transparency is preserved. A call to
-- @{emulator.surface:premultiply|surface:premultiply} might be necessary for
-- transparency to work.
--
-- @param path Location of image file
--
-- @raise Error if enough graphics memory cannot be allocated.
-- @return Surface with image contents
-- @see emulator.gfx.loadjpeg
-- @zenterio
function gfx.loadpng(path)
	local image = surface()
	image:_load_image(path)
	return image
end

--- Load JPEG as a new surface
--
-- Loads the JPEG image at path into a new surface that is returned. The image
-- is always translated to 32-bit RGBA. All pixels will be opaque since JPEG
-- does not support transparency.
--
-- @param path Location of image file
--
-- @raise Error if enough graphics memory cannot be allocated.
-- @return Surface with image contents
-- @see emulator.gfx.loadpng
-- @zenterio
function gfx.loadjpeg(path)
	local image = surface()
	image:loadImage(path)
	return image
end

--- Get memory usage in bytes.
--
-- Returns the number of bytes of graphics memory the application currently uses.
-- Each allocated pixel uses 4 bytes since all surfaces are 32-bit. A limit of
-- @{emulator.gfx.get_memory_limit|gfx.get_memory_limit} is enforced.
--
-- @return Number of bytes of memory used
-- @see emulator.gfx.get_memory_limit
-- @zenterio
function gfx.get_memory_use()
	--Not currently implemented
end


--- Get memory limit in bytes.
-- @return Maximum memory usage in bytes
-- @see emulator.gfx.get_memory_use
-- @zenterio
function gfx.get_memory_limit()
	--Not currently implemented
end


--- Redraw screen.
-- Makes any pending changes to gfx.screen visible.
-- @see emulator.gfx.set_auto_update
-- @zenterio
function gfx.update()
	-- Replace existing draw function with a new one that renders the current
	-- snapshot of the screen
	local image = love.graphics.newImage(screen.image_data)
	function love.draw()
		love.graphics.draw(image)
	end
	collectgarbage()
end

--- Set auto update.
--
-- If set to true, any change to gfx.screen immediately triggers gfx.update()
-- to make the change visible. This slows the system if the screen is updated
-- in multiple steps but is useful for interactive development.
--
-- This should never be set to true in production.
--
-- @param bool True when auto update is desired, otherwise false
-- @see emulator.gfx.update
-- @zenterio
function gfx.set_auto_update(bool)
	--Not currently implemented
end

--- Surface of screen
--
-- The surface that shows up on the screen when @{emulator.gfx.update|gfx.update}
-- is called. Calling @{emulator.gfx.set_auto_update|gfx.set_auto_update}(true)
-- makes the screen update automatically when @{emulator.gfx.screen|gfx.screen}
-- is changed (for development; too slow for animations)
--
-- The main screen defaults to 1280x720 in emulator.
--
-- @zenterio
screen = gfx.new_surface(1280, 720)

return gfx
