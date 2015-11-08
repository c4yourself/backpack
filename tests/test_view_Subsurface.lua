local class = require("lib.classy")
local luaunit = require("luaunit")
local event = require("lib.event")
local utils = require("lib.utils")
local Subsurface = require("lib.view.Subsurface")

local TestSubsurface = {}

function TestSubsurface:setUp()
	subsurface = Subsurface(screen,{width=100, height=100, x=0, y=0})
end

function TestSubsurface:test_dimensions()
	luaunit.assertEquals(subsurface:get_height(), 100)
	luaunit.assertEquals(subsurface:get_width(), 100)
end

return TestSubsurface
