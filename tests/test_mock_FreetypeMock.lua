local class = require("lib.classy")
local FreetypeMock = require("lib.mocks.FreetypeMock")

local TestFreetypeMock = {}

function TestFreetypeMock:test_draw_over_surface()
  c = {
    r = 1,
    g = 10,
    b = 32,
    a = 40
  }
  --local freetype = FreetypeMock(c, 5, {x=40, y=50}, utils.absolute_path("data/fonts/DroidSans.ttf"))
    local freetype = FreetypeMock(c, 5, {x=40, y=50}, "hej")
    FreetypeMock.draw_over_surface(freetype, "Text")
end

return TestFreetypeMock
