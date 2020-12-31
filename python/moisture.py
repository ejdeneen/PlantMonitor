import paho.mqtt.client as mqtt
import schedule
import time
import telegram

cid = PUT_YOUR_CHAT_ID_HERE
bot = telegram.Bot(token=PUT_YOUR_API_KEY_HERE)

#bot.sendMessage(chat_id=cid, text="Your plant is DYING! Give her some water. Let her hydrate. Don't make her dye-drate.")

def on_connect(client, userdata, flags, rc):
    print("connected!")
    client.subscribe("moisture/reading/#")

def on_message(client, userdata, msg):
    payload = int(msg.payload.decode("utf-8"))
    print(payload)
    if payload >= 400:
        bot.sendMessage(chat_id=cid, text="Your plant is DYING! Give her some water. Let her hydrate. Don't make her dye-drate.")
    else:
        bot.sendMessage(chat_id=cid, text="Your plant is doing A-OK :-)")
def on_sample():
    client.publish("moisture/command", "read")

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.username_pw_set(BROKER_USER, BROKER_PASSWORD)

client.connect(BROKER_IP, 1883, 60)

client.loop_start()
schedule.every().day.at("07:30").do(on_sample)

while True:
    schedule.run_pending()
    time.sleep(60)