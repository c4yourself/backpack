local LuaUnit = require("luaunit")

-- Enable import as if we were executing from the actual program
package.path = "../?.lua;" .. package.path

-- Make mocks global
gfx = require("lib.mocks.GfxMock")
surface = require("lib.mocks.SurfaceMock")
player = require("lib.mocks.PlayerMock")
freetype = require("lib.mocks.FreetypeMock")
sys = require("lib.mocks.SysMock")
screen = surface(1280, 720)

-- Replace require
local _require = require
function require(module)
	if module == "lib.draw.Font" then
		return _require("lib.mocks.FontMock")
	else
		return _require(module)
	end
end

-- Make sure logging is disabled since it can interfere with the tests
local config = require("config")
config.logging.mode = "DISABLED"

-- All tests should be included from here
TestRectangle = require("test_rectangle")
TestBit = require("test_bit")
TestColor = require("test_color")
TestEvent = require("test_event")
TestHash = require("test_hash")
TestLogger = require("test_logger")
TestUtils = require("test_utils")
TestView = require("test_view_View")
TestConnectFour = require("test_connectfour")
TestViewManager = require("test_view_ViewManager")
--TestNumericalInputComponent = require("test_components_NumericalInputComponent")
TestNumerical = require("test_numerical")
TestIntegrationNumerical = require("test_integration_numerical")
TestTSV = require("test_tsvreader")
TestProfile = require("test_profile")
TestMemory = require("test_memory")
TestExperienceCalculation = require("test_experiencecalculation")
TestCity = require("test_City")
TestCountry = require("test_Country")
--Mocks
TestTimerMock = require("mocks.test_mock_TimerMock")
TestGfxMock = require("mocks.test_mock_GfxMock")
TestFreetypeMock = require("mocks.test_mock_FreetypeMock")
TestPlayerMock = require("mocks.test_mock_PlayerMock")
TestSysMock = require("mocks.test_mock_SysMock")
TestSurfaceMock = require("mocks.test_mock_SurfaceMock")
TestFontMock = require("mocks.test_mock_FontMock")
--integration
--TestMockIntegration = require("integration.test_mock_integration")
--views
--TestStore = require("view.test_store")
TestSplashView = require("view.test_SplashView")


lu = LuaUnit.LuaUnit.new()
os.exit(lu:runSuite())
