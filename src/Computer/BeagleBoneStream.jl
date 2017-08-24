export BeagleBoneStream, init_devices!, send!

struct BeagleBoneStream <: LabStream
    devices::Array{Device,1}
    stream::TCPSocket
end

function BeagleBoneStream(addr::IPAddr, port::Int64=2001)
    clientside = connect(addr, port)
    BeagleBoneStream(Device[], clientside)
end

#For BeagleBoneStream we can directly serialize the data, other streams might want to send binary data
serialize(bbstream::BeagleBoneStream, cmd) = serialize(bbstream.stream, cmd)

function init_devices!(bbstream::BeagleBoneStream, devs::Device...)
    for dev in devs
        if dev ∉ bbstream.devices
            setstream!(dev, bbstream)
            push!(bbstream.devices, dev)
            initialize(dev)
        else
            warn("Device $dev already added to a stream")
        end
    end
    return
end

function send!(stream::BeagleBoneStream)
    cmds = Tuple[]
    for dev in stream.devices
        val = getsetvalue(dev)
        cmd, devstream = safe_getwritecommand(dev, val)
        devstream == stream || error("Device $dev is connected to other stream $devstream")
        push!(cmds, cmd)
    end
    ncmds = Int32(length(cmds))
    if ncmds > 0
        allcmds = (true, ncmds, cmds...)
        println("Sending command: $allcmds")
        serialize(stream, allcmds)
    end
    return
end
function read(stream::BeagleBoneStream)
    cmds = Tuple[]
    for dev in stream.devices
        cmd, devstream = safe_getreadcommand(dev)
        devstream == stream || error("Device $dev is connected to other stream $devstream")
        push!(cmds, cmd)
    end
    ncmds = Int32(length(cmds))
    if ncmds > 0
        allcmds = (false, ncmds, cmds...)
        println("Sending command: $allcmds")
        serialize(stream, allcmds)
        #TODO save values in dev
        # update_read_vale!(dev, val)
    end
    return
end

function close(bbstream::BeagleBoneStream)
    cmds = Tuple[]
    for dev in bbstream.devices
        close(dev)
    end
    close(bbstream.stream)
    return
end
