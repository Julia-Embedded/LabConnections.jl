export BeagleBoneStream, init_devices!

struct BeagleBoneStream <: LabStream
    devices::Array{AbstractDevice,1}
    sendbuffer::Array{Tuple,1}
    readbuffer::Array{Tuple,1}
    stream::TCPSocket
end

function BeagleBoneStream(addr::IPAddr, port::Int64=2001)
    clientside = connect(addr, port)
    BeagleBoneStream(AbstractDevice[], Tuple[], Tuple[], clientside)
end

#For BeagleBoneStream we can directly serialize the data, other streams might want to send binary data
serialize(bbstream::BeagleBoneStream, cmd) = serialize(bbstream.stream, cmd)

function init_devices!(bbstream::BeagleBoneStream, devs::AbstractDevice...)
    for dev in devs
        if dev ∉ bbstream.devices
            setstream!(dev, bbstream)
            push!(bbstream.devices, dev)
            initialize(dev)
            # Send to beaglebone 2: initialize, 1 device, (name, index)
            # TODO create proper functionality to initialize
            readcmd = getreadcommand(bbstream, dev)
            name = readcmd[1]::String
            idx = readcmd[2]::Integer
            serialize(bbstream.stream, (Int32(2), Int32(1), (name, Int32(idx))))
        else
            warn("Device $dev already added to a stream")
        end
    end
    return
end

function send(bbstream::BeagleBoneStream)
    ncmds = length(bbstream.sendbuffer)
    serialize(bbstream.stream, (Int32(1), Int32(ncmds), bbstream.sendbuffer...))
    empty!(bbstream.sendbuffer)
    return
end
#TODO know the types of outputs some way
function read(bbstream::BeagleBoneStream)
    ncmds = length(bbstream.readbuffer)
    serialize(bbstream.stream, (Int32(0), Int32(ncmds), bbstream.readbuffer...))
    empty!(bbstream.readbuffer)
    vals, timestamps = deserialize(bbstream.stream)
    length(vals) == ncmds || error("Wrong number of return values in $vals on request $(bbstream.readbuffer)")
    #TODO Do something with timestamps
    return (vals...,) #Converting from array to tuple
end

#The following are for interal use only
function send(bbstream::BeagleBoneStream, cmd)
    allcmds = (Int32(1), Int32(1), cmd)
    println("Sending single command: $allcmds")
    serialize(bbstream.stream, allcmds)
    return
end
function read(bbstream::BeagleBoneStream, cmd)
    allcmds = (Int32(0), Int32(1), cmd)
    println("Sending single command: $allcmds")
    serialize(bbstream.stream, allcmds)
    vals, timestamps = deserialize(bbstream.stream)
    length(vals) == 1 || error("Wrong number of return values in $vals on request $cmd")
    #TODO Do something with timestamps
    return vals[1], timestamps[1]
end

function close(bbstream::BeagleBoneStream)
    cmds = Tuple[]
    for dev in bbstream.devices
        close(dev)
    end
    close(bbstream.stream)
    return
end
