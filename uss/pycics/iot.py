import paho.mqtt.client as mqtt

# MQTT Broker details
BROKER = "test.mosquitto.org"
PORT = 1883
TOPIC = "IBMZ"
MESSAGE = "Hello MQTT from Python!"

def main():
    # Create an MQTT client instance
    client = mqtt.Client()

    # Connect to broker
    print(f"Connecting to {BROKER}:{PORT}")
    client.connect(BROKER, PORT, 60)

    # Publish a message
    print(f"Publishing message '{MESSAGE}' to topic '{TOPIC}'")
    client.publish(TOPIC, MESSAGE)

    # Disconnect
    client.disconnect()
    print("Disconnected from broker")

if __name__ == "__main__":
    main()
