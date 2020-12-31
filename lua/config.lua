-- file : config.lua
local module = {}

module.SSID = {}
module.SSID["YOUR_SSID"] = "YOUR_WIFI_PASSWORD"

module.HOST = "BROKER_IP"
module.PORT = 1883
module.ID = "moisture"
module.USER = "BROKER_USER"
module.PASS = "BROKER_PASSWORD"

module.ENDPOINT = "medusa"
return module  
