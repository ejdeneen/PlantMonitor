-- file : application.lua
local module = {}
local adc_timer   = tmr.create()  
local active = false
m = nil

local function read_adc(t)
--    reading = (31 - (adc.read(0) * 0.03))
--    if(reading < 0) then reading = 0 end
--    print("inches: "..reading)
  --  m:publish(config.ENDPOINT .. config.ID, reading, 0, 0)
    print(adc.read(0)) 
    local value = adc.read(0)
    gpio.write(1, gpio.LOW)
    active = false
    m:publish("moisture/reading/medusa", value, 0, 0)
end

local function enable_relay(t)
    if active == true then return end
    active = true
    gpio.write(1, gpio.HIGH) -- :-)
    adc_timer:register(1000*5, tmr.ALARM_SINGLE, read_adc)
    adc_timer:start()
end

local function on_message(client, topic, message)
    if topic == "moisture/command" then
        if message == "read" then
            enable_relay()
        end
    end
end

local function mqtt_start()  
    m = mqtt.Client(config.ID, 120, config.USER, config.PASS)
    -- Connect to broker
    m:connect(config.HOST, config.PORT, false, function(con) 
        print("Connected!!!!")
        m:subscribe("moisture/command", 0)
        m:on("message", on_message)
    end) 

end

function module.start()
  mqtt_start()
  gpio.mode(1, gpio.OUTPUT)
  gpio.write(1, gpio.LOW)
end

return module
