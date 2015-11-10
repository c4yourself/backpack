-- Bootstrap for emulator
zto = require("emulator.zto")
gfx = require("emulator.gfx")
surface = require("emulator.surface")
player = require("emulator.player")
freetype = require("emulator.freetype")
sys = require("emulator.sys")

require(os.getenv("MODULE") or "start")
