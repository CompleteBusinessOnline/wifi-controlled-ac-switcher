return function (connection, req, args)
	file.remove("settings.lua")
	
	connection:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
	connection:send('{"error":0, "message":"OK"}')
	
	node.restart()
end