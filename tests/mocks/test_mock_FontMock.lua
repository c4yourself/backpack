local luaunit = require("luaunit")
local class = require("lib.classy")
local FontMock = require("lib.mocks.FontMock")
local Color = require("lib.draw.Color")


local TestFontMock = {}

--SetUp for the font
function TestFontMock:setUp()
	TestFontMock.test_font = FontMock("data/fonts/DroidSans.ttf", 40, Color(255, 255, 255, 255))
	rectangle = {
		x = 50,
		y = 50,
		width = 50,
		height = 50
	}
end

--Test different functioanlity with draw, it is not really suppose to do anything
function TestFontMock:test_draw()
	luaunit.assertNil(TestFontMock.test_font:draw(screen, rectangle, "nothing", "does nothing"))
	luaunit.assertNil(TestFontMock.test_font:draw(screen, rectangle))
	luaunit.assertNil(TestFontMock.test_font:draw("hejsa", "vaad"))
end


return TestFontMock
