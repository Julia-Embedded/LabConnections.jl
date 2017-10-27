include("IO_Object.jl")
include("Debug.jl")
include("SysLED.jl")
include("GPIO.jl")
include("PWM.jl")

#List of available devices and their constructors
const DEVICES = Dict("debug" => Debug, "sysled" => SysLED, "gpio" => GPIO, "pwm" => PWM)

#Currently active devices on the BeagleBone
active_devices = Dict{String,Dict{Int32,IO_Object}}("debug" => Dict{Int32,Debug}(), "sysled" => Dict{Int32,SysLED}(),
                                                          "gpio" => Dict{Int32,GPIO}(), "pwm" => Dict{Int32,PWM}())

"""
    active_device = initdev(dev_name::String, i:Int32)
Initializes a new device of type 'dev_name' at index 'i' on the BeagleBone,
and adds it to the dict of currently active devices. Returns the initialized
device 'active_device'.
"""
function initdev(dev_name::String, i::Int32)
    #Check if the type of device is valid
    dev_constr = try
         DEVICES[dev_name]
     catch
         error("Device $dev_name does not exist")
     end
    #Check if the device index is already in use
    haskey(active_devices[dev_name],i) && error("Index $i is already in use for device $dev_name")
    #Construct a new device and add it to dict of currently active devices
    active_device = dev_constr(i)
    active_devices[dev_name][i] = active_device
    return active_device
end

"""
    closedev(dev_name::String, i::Int32)
Closes down a currently active device of type 'dev_name' at index 'i' on the BeagleBone,
and removes it from the dict of currently active devices.
"""
function closedev(dev_name::String, i::Int32)
    active_device = try
        active_devices[dev_name][i]
    catch
        error("No device of type $dev_name at index $i is currently active")
    end
    #Call the teardown method on the device, to close all file-streams and
    #unexport the device from the BeagleBone
    teardown(active_device)

    #Remove the device from the dict of active devices
    delete!(active_devices[dev_name], i)
end

"""
    dev = getdev(dev_name::String, i::Int32)
Retrieves the active device of type `dev_name` at index 'i'
"""
function getdev(dev_name::String, i::Int32)
    dev = try
        active_devices[dev_name][i]
    catch
        error("No device of type $dev_name at index $i is currently active")
    end
    return dev
end

"""
    message = listdev()
Lists all the active devices as an insidence array for testing
"""
function listdev()
    message = "Complete overview of active devices"
    count = zeros(length(keys(DEVICES)))
    for (index, key) in enumerate(keys(DEVICES))
        count[index] = length(active_devices[key])
    end
    return count
end

"""
    message = printdev()
Prints all the active devices and writes out specifics of a single devices
"""
function printdev(dev_name::String, i::Int32)
    println("Complete overview of active devices")
    for (index, key) in enumerate(keys(DEVICES))
        println(" *    $(key) - $(length(active_devices[key]))")
    end
    try
        dev = active_devices[dev_name][i]
        println(to_string(dev))
    catch
        println("\nNo device of type $dev_name at index $i is currently active")
    end
end

"""
    bbparse(cmd)
Parse and execute the command `cmd`
"""
bbparse(any) = error("Unexpected input: $any")


function bbsend(sock, vals)#, timestamps)
    serialize(sock, vals)#, (timestamps...)))
end

"""
    bbparse(l::Tuple, sock)
Parse input on the form `l=(iswrite, ndev, cmd1, cmd2, ..., cmdn)`
where if `iswrite`
    `cmdi = (devname, id, val)`
    and if not `iswrite`
    `cmdi = (devname, id)`

and send back on socket (vals, timestamps)
"""
function bbparse(l::Tuple, sock)
    iswrite = l[1]::Bool            #True if write command, false if read
    ndev = l[2]::Int32              #Number of devices/commands
    if iswrite
        for i = 1:ndev
            command = l[2+i]::Tuple
            dev = getdev(command[1], command[2])
            write!(dev, command[3])
        end
        return
    else
        #TODO fix to have at least partial type stability
        vals = Array{Any,1}(ndev)
        timestamps = Array{UInt64,1}(ndev)
        for i = 1:ndev
            command = l[2+i]::Tuple
            dev = getdev(command[1], command[2])
            vals[i] = read(dev)
            timestamps[i] = UInt64(0)#time_ns()
        end
        bbsend(sock, (vals, timestamps))
        return
    end
end

global __waiting_first_connection__ = false
"""
    run_server(port=2001; debug=false)
Run a server on `port` that listens for commands from computer
Optional debug keyword disables blinking system leds
"""
function run_server(port=2001; debug=false)
    global __waiting_first_connection__ = true
    server = listen(port)
    @async while isopen(server)
        try
            @async while __waiting_first_connection__ && !debug
                #Blink SysLED 2 when waiting for first connection to signal availability
                led = initdev("sysled",Int32(2))
                write!(led, "1")
                sleep(0.4)
                write!(led, "0")
                sleep(0.2)
                write!(led, "1")
                sleep(0.4)
                write!(led, "0")
                sleep(0.8)
                closedev("sysled", Int32(2))
            end
            sock = accept(server)
            __waiting_first_connection__ = false
            @async while isopen(sock)
                try
                    l = deserialize(sock);
                    bbparse(l, sock)
                catch err
                    if !isopen(sock) && (isa(err, Base.EOFError) || isa(err, Base.UVError))
                        println("Connection to server closed")
                    else
                        println("error: $(typeof(err))")
                        throw(err)
                    end
                end
            end
        catch err
            if isa(err,Base.UVError) && err.prefix == "accept"
                println("Server closed successfully")
            else
                throw(err)
            end
        end
    end
    return server
end
