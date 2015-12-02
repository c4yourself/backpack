local luaunit = require("luaunit")
local class = require("lib.classy")
local SplashView = require("views.SplashView")

local TestSplashView = {}

function TestSplashView:setUp()
	TestSplashView.splash_screen = SplashView("data/images/logo.png", "nothing", "nothing")
end

function TestSplashView:test_run()
	TestSplashView.splash_screen:start(1)
	TestSplashView.splash_screen:render(screen)
end


return TestSplashView
