
local class = require("lib.classy")
local logger = require("lib.logger")
local SurfaceMock = class("SurfaceMock")

function SurfaceMock:__init(width, height)
  surfacemock = {}
  for i= 1, heigth do
    surfacemock[i] = {}
    for j = 1, widht do
      surfacemock[i][j] = 0
    end
  end
end

function SurfaceMock:clear(color, rectangle)
end
