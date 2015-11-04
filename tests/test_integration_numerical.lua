local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local SurfaceMock = require("lib.mocks.SurfaceMock")

local TestIntegrationNumerical = {}

function TestIntegrationNumerical:setUp()
	self.SurfaceMock = SurfaceMock(720, 1080)
end

function TestIntegrationNumerical:test_defaults()

end

return TestIntegrationNumerical
