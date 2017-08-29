#On beaglebone, run:
# include("LabConnections/src/LabConnections.jl")
# using LabConnections.BeagleBone
# run_server()

using LabConnections.Computer

stream = BeagleBoneStream(ip"192.168.7.2")
led1 = SysLED(1)
led2 = SysLED(2)
led3 = SysLED(3)
led4 = SysLED(4)

# Send info to steam about which inputs/otputs to initialize
# and adds a ref in motor and led to stream
init_devices!(stream, led1, led2, led3, led4)
ledon = true
for i = 1:50
    set!(led1, ledon)
    set!(led2, !ledon)
    set!(led3, ledon)
    set!(led4, !ledon)
    send(stream) #Sends all the outputs to the stream in one atomic call
    #read(stream) #Sends request to read, reads all inputs
    sleep(0.1)
    ledon = !ledon
end
for i = 1:40
    send(led1, ledon)
    sleep(0.03)
    send(led2, ledon)
    sleep(0.03)
    send(led3, ledon)
    sleep(0.03)
    send(led4, ledon)
    sleep(0.03)
    ledon = !ledon
end
set!(led1, false)
set!(led2, false)
set!(led3, false)
set!(led4, false)
send(stream)
close(stream) #Tells BeagleBone to stop listening and close outputs
