import serial
import sys
import time

port = '/dev/ttyUSB0' # Change this to your serial port
baud_rate = 9600     # Change this to your baud rate

# Hexadecimal string to send (e.g., "01 02 AF")
hex_string = "26 0A 0D"

# Convert hex string to bytes
# Remove spaces and convert to bytes
for i in range(200):
    try:
        ser = serial.Serial(port, baud_rate, timeout=1, rtscts=False, dsrdtr=False)
        print(f"Opened serial port {port} at {baud_rate} bps")
        #print(f"Sending bytes: {byte_data.hex().upper()}")

        ser.write(b'2')
        ser.write(b'6')
        ser.write(b'\n')
        print("Bytes sent.")

        response = ser.read_until(b'\n') # or ser.read_all() or ser.read(number_of_bytes)
    
        if response:
            print(f"Received response: {response.decode().strip()}") 
        else:
            print("No response received within the timeout period.")

        time.sleep(0.5)
        ser.close()
    except serial.SerialException as e:
        print(f"Error: {e}")
        sys.exit(1)

