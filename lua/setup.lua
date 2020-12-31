-- file: setup.lua
local module = {}

local function wifi_start(list_aps)  
    if list_aps then
        for key,value in pairs(list_aps) do
            if config.SSID and config.SSID[key] then
                local sta_config = {}
                sta_config.save = false
                sta_config.auto = false
                sta_config.ssid = key
                sta_config.pwd = config.SSID[key]
                
                wifi.sta.config(sta_config)
                wifi.sta.connect()
		        return
            end
        end
    end
    wifi.sta.getap(wifi_start)
end

function module.start()
  print("Configuring Wifi ...")
  wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function() node.restart() end)
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function() app.start() end)
  wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, function() node.restart() end)
  wifi.setmode(wifi.STATION)
  wifi.sta.getap(wifi_start)
end

return module
