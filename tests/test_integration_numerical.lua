local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local SurfaceMock = require("lib.mocks.SurfaceMock")
local numerical_quiz = require("views.numerical_quiz")

local TestIntegrationNumerical = {}

function TestIntegrationNumerical:setUp()
  self.SurfaceMock = SurfaceMock(720, 1080)
end

function TestIntegrationNumerical:test_defaults()
  --numerical_quiz.render(self.SurfaceMock)
end

return TestIntegrationNumerical
