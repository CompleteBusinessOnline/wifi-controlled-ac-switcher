local function on(connection, pin)
	
	gpio.write(pin, gpio.HIGH)

	-- Send back JSON response.
	connection:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
	connection:send('{"error":0, "message":"OK"}')

end

return function (connection, req, args)
	on(connection, args.pin)
end
