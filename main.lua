-- Bootstrap for emulator
zto = require("emulator.zto")
gfx = require("emulator.gfx")
surface = require("emulator.surface")
player = require("emulator.player")
freetype = require("emulator.freetype")
sys = require("emulator.sys")

-- Patch require to prevent import of emulator files
local _require = require
function require(module)
	if module:sub(1, 9) == "emulator." then
		error("Rogue emulator import: " .. module)
	end
	return _require(module)
end

require(os.getenv("MODULE") or "start")
