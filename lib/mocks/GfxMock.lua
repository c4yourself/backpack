-- Gfx mock class

local class = require("lib.classy")
local SurfaceMock = require("lib.mocks.SurfaceMock")
local GfxMock = class("GfxMock")

-- Attributes initialized
local memory_limit = 1
local memory_usage = 0
--local screen = GfxMock:new_surface(1280, 720)


-- Create and return a surface mock
function GfxMock:new_surface(width, height)
	local image_data = SurfaceMock(width, height)
	return image_data
end

-- Create and return a Surface Mock
function GfxMock:loadjpeg(path)
	local image_data = SurfaceMock(1080, 720)
	return image_data
end

-- Create and return a Surface Mock
function GfxMock:loadpng(path)
	local image_data = SurfaceMock(1080, 720)
	return image_data
end

-- Return memory_limit
function GfxMock:get_memory_limit()
  return memory_limit
end

-- Return memory_usage
function GfxMock:get_memory_use()
	return memory_usage
end

-- Function that is needed but does nothing
function GfxMock:update()
  -- Does nothing
end

-- Function that is needed but does nothing
function GfxMock:set_auto_update(bool)
  -- Does nothing
end

return GfxMock
