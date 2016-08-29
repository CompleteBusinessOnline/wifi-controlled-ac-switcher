dofile("init-compile.lua")

local function pinToBinary(val)
	local val = tonumber(val)
	if(val>=128) then
		gpio.write(1, gpio.HIGH)
		val = val - 128
	end
	if(val>=64) then
		gpio.write(2, gpio.HIGH)
		val = val - 64
	end
	if(val>=32) then
		gpio.write(3, gpio.HIGH)
		val = val - 32
	end
	if(val>=16) then
		gpio.write(5, gpio.HIGH)
		val = val - 16
	end
	if(val>=8) then
		gpio.write(6, gpio.HIGH)
		val = val - 8
	end
	if(val>=4) then
		gpio.write(7, gpio.HIGH)
		val = val - 4
	end
	if(val>=2) then
		gpio.write(8, gpio.HIGH)
		val = val - 2
	end
	if(val==1) then
		gpio.write(9, gpio.HIGH)
		val = val - 1
	end
	collectgarbage()
end

local function apServe(cfg)
	wifi.setmode(wifi.SOFTAP)
	wifi.ap.config(cfg)
	gpio.write(4, gpio.LOW)
	collectgarbage()
	dofile("httpserver.lc")(80)
end

local function staServe()
	local ipAddr, netmask, gateway = wifi.sta.getip()
	local i = 0
	local ip = 0
	for elem in ipAddr:gmatch("%d+") do
		if(i==3) then
			ip = elem
		end
		i = i + 1
	end
	pinToBinary(ip)
	gpio.write(4, gpio.LOW)
	collectgarbage()
	dofile("httpserver.lc")(80)
end

local function resetPins()
	for i=1, 9, 1
	do
		gpio.write(i, gpio.LOW)
	end
	collectgarbage()
end

dofile("init-gpio.lc")

local wifiConfig, runAp = dofile("init-conf.lc")

if(runAp==true) then
	apServe(wifiConfig.accessPointConfig)
end
runAp = nil

if (wifi.getmode() == wifi.STATION) then
	print("station config ("..wifiConfig.stationPointConfig.ssid..","..wifiConfig.stationPointConfig.pwd..")")
	wifi.sta.config(wifiConfig.stationPointConfig.ssid, wifiConfig.stationPointConfig.pwd)
	
	local joinCounter = 0
    local joinMaxAttempts = 4
	local pinNo = 1
	tmr.alarm(0, 5000, 1, function() 
		if wifi.sta.getip()==nil then
			gpio.write(pinNo, gpio.HIGH)
			if(pinNo==3) then
				gpio.write(pinNo+2, gpio.HIGH)
				pinNo = pinNo + 3
			else
				gpio.write(pinNo+1, gpio.HIGH)
				pinNo = pinNo + 2
			end
			
			if joinCounter == joinMaxAttempts then
				print('Failed to connect to WiFi Access Point.')
				collectgarbage()
				resetPins()
				apServe(wifiConfig.accessPointConfig)
				tmr.stop(0)
			else
				print("Connecting to AP...")
				joinCounter = joinCounter + 1
			end
		else
			print("Connection successful")
			collectgarbage()
			resetPins()
			staServe()
			tmr.stop(0)
		end
	end)
end