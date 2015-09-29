return {
	-- True when running inside an emulator
	is_emulator = love ~= nil,
	-- IP of set-top box (used by debugging functions in backpack script)
	box_ip = "127.0.0.1",
	logging = {
		-- Logging level:
		--   May be either TRACE, DEBUG, WARN or ERROR
		level = "WARN",
		-- Logging mode:
		--   CONSOLE means log messages will be printed to STDOUT
		--   UDP means log messages will be sent over UDO to listener defined below
		--   Anything else means the dummy logger (to be used for production)
		mode = "CONSOLE",
		-- Listener:
		--   Target for all log messages when mode is UDP
		--   {"ipaddressoftarget", port}
		listener = {"127.0.0.1", 12024},
		-- Log memory:
		--   When true all log messages will include current memory usage
		log_memory = false
	}
}
