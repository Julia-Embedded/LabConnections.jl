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
for i = 1:100
    put!(led1, ledon)
    put!(led2, !ledon)
    put!(led3, ledon)
    put!(led4, !ledon)
    send(stream) #Sends all the outputs to the stream in one atomic call
    #read(stream)
    get(led1)
    get(led2)
    get(led3)
    #sleep(0.1)
    v1,v2,v3 = read(stream) #Sends request to read, reads all inputs for which get! was called
    v1 == !v2 == v3 == ledon ? nothing : println("ledon is $ledon, but read v1, v2, v3 = $v1, $v2, $v3")
    ledon = !ledon
end
for i = 1:40
    send(led1, ledon)
    #sleep(0.03)
    v1 = read(led1)
    send(led2, ledon)
    #sleep(0.03)
    v2 = read(led2)
    send(led3, ledon)
    #sleep(0.03)
    v3 = read(led3)
    send(led4, ledon)
    #sleep(0.03)
    v4 = read(led4)
    v1 == v2 == v3 == v4 == ledon ? nothing : println("ledon is $ledon, but read v1, v2, v3, v4 = $v1, $v2, $v3, $v4")
    ledon = !ledon
end
put!(led1, false)
put!(led2, false)
put!(led3, false)
put!(led4, false)
send(stream)
close(stream) #Tells BeagleBone to stop listening and close outputs
