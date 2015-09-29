title = "Back-to-BackPack Reference Documentation"
project = "Back-to-BackPack"
description = "Back to Back-Pack project"
readme = "README.md"
format = "discount"
file = {
	"lib/",
	"emulator/"
}
no_space_before_args = true
custom_tags = {
	{
		"zenterio",
		title = "Zenterio API",
		hidden = false,
		format = function(item)
			return "Part of the Zenterio Lua API. Available on set-top box."
		end
	}
}
