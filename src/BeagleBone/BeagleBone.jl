# AbstractDevice should define a type `T` with methods:
# write!(::T, identifier, val)
# read(::T, identifier)

include("Debug.jl")
include("SysLED.jl")
include("GPIO.jl")
include("PWM.jl")

#List of available devices and their constructors
const DEVICES = Dict("debug" => Debug(), "sysled" => SysLED(), "gpio" => GPIO(), "pwm" => PWM())

"""
    dev = getdev(devname)
    Gets the device corresponding to the name `devname`
"""
function getdev(devname)
    dev = try
        DEVICES[devname]
    catch
        error("Device $devname does not exist")
    end
    return dev
end

"""
    bbparse(cmd)
Parse and execute the command `cmd`
"""
bbparse(any) = error("Unexpected input: $any")

"""
    bbparse(l::Tuple)
Parse input on the form `l=(iswrite, ndev, cmd1, cmd2, ..., cmdn)``
where if `iswrite`
    `cmdi = (devname, id, val)`
    and if not `iswrite`
    `cmdi = (devname, id)`
"""
function bbparse(l::Tuple)
    iswrite = l[1]::Bool            #True if write command, false if read
    ndev = l[2]::Int32              #Number of devices/commands
    for i = 1:ndev
        command = l[2+i]::Tuple
        dev = getdev(command[1])
        if iswrite
            write!(dev, command[2], command[3])
        else
            val = read(dev, command[2])
            println("$val")
            #TODO return somewhere
        end
    end
end

global __waiting_first_connection__ = false
"""
    run_server(port=2001)
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
                led = SysLED()
                write!(led, 2, true)
                sleep(0.4)
                write!(led, 2, false)
                sleep(0.2)
                write!(led, 2, true)
                sleep(0.4)
                write!(led, 2, false)
                sleep(0.8)
            end
            sock = accept(server)
            __waiting_first_connection__ = false
            @async while isopen(sock)
                try
                    l = deserialize(sock);
                    println("deserialize: $l")
                    bbparse(l)
                catch err
                    if !isopen(sock) && isa(err, Base.EOFError)
                        println("Connection to server closed")
                    else
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
