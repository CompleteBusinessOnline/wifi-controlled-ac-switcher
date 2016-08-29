local function off(connection, pin)
	
	gpio.write(pin, gpio.LOW)

	-- Send back JSON response.
	connection:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
	connection:send('{"error":0, "message":"OK"}')

end

return function (connection, req, args)
	off(connection, args.pin)
end
