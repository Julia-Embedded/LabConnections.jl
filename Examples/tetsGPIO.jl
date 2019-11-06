using LabConnections.Computer
using Sockets

stream = BeagleBoneStream(ip"192.168.7.2")

gpio112 = GPIO(1, true)     # Writing P9.30 (according to setup specification on BB)
gpio66 = GPIO(29, false)    # Reading P8.7

init_devices!(stream, gpio112, gpio66)

send(gpio112, true)
val = read(gpio112)
