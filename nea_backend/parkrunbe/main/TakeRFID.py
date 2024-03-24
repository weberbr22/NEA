import serial
from serial.tools import list_ports
import time
import Event


device = '/dev/cu.usbmodem101' # USB Line

arduino = serial.Serial(device, 9600) # Create an Arduino Object on 9600 baud

def ShowCodes():

    while True:

        data = arduino.readline().decode('utf-8').strip()

        if data.startswith("Card UID: "):
            EPC = data.split(": ")[1] # Take second half of string

            if EPC == "04 8B CA AB 67 26 81": # When this tag is scanned, end the event
                killevent = "KILL EVENT"
                print(killevent)
                return killevent
            
            else:
                print("Code Taken: "+EPC)
                return EPC

