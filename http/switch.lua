local function switch(connection, pin)

	val = gpio.read(pin)
	if(val==0) then
		val = 1
	else
		val = 0
	end
	
	gpio.write(pin, val)

	-- Send back JSON response.
	connection:send("HTTP/1.0 200 OK\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n")
	connection:send('{"error":0, "message":"OK"}')

end

return function (connection, req, args)
	switch(connection, args.pin)
end
