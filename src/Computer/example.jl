include("server.jl")

stream = BeagleBoneStream(ip"127.0.0.1")
led2 = SysLED(2)
led3 = SysLED(3)

# Send info to steam about which inputs/otputs to initialize
# and adds a ref in motor and led to stream
init_devices!(stream, led2, led3)
ledon = true
for i = 1:10
    set!(led2, ledon)
    set!(led3, !ledon)
    send!(stream) #Sends all the outputs to the stream in one atomic call
    #read(stream) #Sends request to read, reads all inputs
    sleep(1)
    ledon = !ledon
end
for i = 1:10
    send!(led2, ledon)
    sleep(0.5)
    send!(led3, !ledon)
    #read(stream) #Sends request to read, reads all inputs
    sleep(0.5)
    led_on = !ledon
end
set!(led2, false)
set!(led3, false)
send!(stream)
close(stream) #Tells BeagleBone to stop listening and close outputs
