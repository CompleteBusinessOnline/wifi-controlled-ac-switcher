local wifiConfig = {}
local runAp = false

wifiConfig.accessPointConfig = {}
wifiConfig.accessPointConfig.ssid = "bumbilyador-"..node.chipid() 
wifiConfig.accessPointConfig.pwd = "password"
wifiConfig.accessPointIpConfig = {}
wifiConfig.stationPointConfig = {}
	
if(file.open("settings.lua")~=nil) then -- station
	wifi.setmode(wifi.STATION)
	wifiConfig.stationPointConfig.ssid = file.readline():gsub("^%s*(.-)%s*$", "%1")
	wifiConfig.stationPointConfig.pwd = file.readline():gsub("^%s*(.-)%s*$", "%1")
else
	runAp = true
end
file.close()

collectgarbage()
return wifiConfig, runAp