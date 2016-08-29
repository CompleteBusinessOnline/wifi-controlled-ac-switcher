for i=0, 9, 1
do
	gpio.mode(i, gpio.OUTPUT)
	if(i==4) then
		gpio.write(i, gpio.HIGH)
	else
		gpio.write(i, gpio.LOW)
	end
end
collectgarbage()