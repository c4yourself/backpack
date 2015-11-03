
local class = require("lib.classy")
local logger = require("lib.logger")
local SurfaceMock = class("SurfaceMock")

function SurfaceMock:__init(width, height)
  self.pixels = {}
  for i= 1, heigth do
    self.pixels[i] = {}
    for j = 1, widht do
      self.pixels[i][j] = 0
    end
  end
end

function SurfaceMock:clear(color, rectangle)

end
