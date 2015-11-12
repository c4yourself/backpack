return {
	-- True when running inside an emulator
	is_emulator = love ~= nil,
	-- IP of set-top box (used by debugging functions in backpack script)
	box_ip = "192.168.1.5",
	logging = {
		-- Logging level:
		--   May be either TRACE, DEBUG, WARN or ERROR
		level = "TRACE",
		-- Logging mode:
		--   CONSOLE means log messages will be printed to STDOUT
		--   UDP means log messages will be sent over UDO to listener defined below
		--   Anything else means the dummy logger (to be used for production)
		mode = "CONSOLE",
		-- Listener:
		--   Target for all log messages when mode is UDP
		--   {"ipaddressoftarget", port}
		listener = {"0.0.0.0", 12024},
		-- Log memory:
		--   When true all log messages will include current memory usage
		log_memory = false
	}
}
