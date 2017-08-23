# Devices should define a type `T` with methods:
# write!(::T, identifier, val)
# read(::T, identifier)

include("SysLED.jl")

#List of available devices and their constructors
const DEVICES = Dict("sysled" => SysLED())

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

"""
    run_server(port=2001)
Run a server on `port` that listens for commands from computer
"""
function run_server(port=2001)
    server = listen(port)
    @async while isopen(server)
        sock = accept(server)
        @async while isopen(sock)
            l = deserialize(sock);
            println("deserialize: $l")
            bbparse(l)
        end
    end
    return server
end
