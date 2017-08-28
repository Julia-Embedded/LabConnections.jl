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
        else
            warn("Device $dev already added to a stream")
        end
    end
    return
end

function send(bbstream::BeagleBoneStream)
    ncmds = length(bbstream.sendbuffer)
    serialize(bbstream.stream, (true, ncmds, bbstream.sendbuffer))
    empty!(bbstream.sendbuffer)
    return
end
function read(comedistream::BeagleBoneStream)
    ncmds = length(bbstream.readbuffer)
    serialize(bbstream.stream, (false, ncmds, bbstream.sendbuffer))
    #TODO wait for answer
    vals = nothing
    empty!(bbstream.sendbuffer)
    return vals
end
# 
# function send(stream::BeagleBoneStream)
#     cmds = Tuple[]
#     for dev in stream.devices
#         val = getsetvalue(dev)
#         cmd, devstream = safe_getwritecommand(dev, val)
#         devstream == stream || error("Device $dev is connected to other stream $devstream")
#         push!(cmds, cmd)
#     end
#     ncmds = Int32(length(cmds))
#     if ncmds > 0
#         allcmds = (true, ncmds, cmds...)
#         println("Sending command: $allcmds")
#         serialize(stream, allcmds)
#     end
#     return
# end
# function read(stream::BeagleBoneStream)
#     cmds = Tuple[]
#     for dev in stream.devices
#         cmd, devstream = safe_getreadcommand(dev)
#         devstream == stream || error("Device $dev is connected to other stream $devstream")
#         push!(cmds, cmd)
#     end
#     ncmds = Int32(length(cmds))
#     if ncmds > 0
#         allcmds = (false, ncmds, cmds...)
#         println("Sending command: $allcmds")
#         serialize(stream, allcmds)
#         #TODO save values in dev
#         # update_read_vale!(dev, val)
#     end
#     return
# end


#Maybe rethink a bit to support IObox
function send(bbstream::BeagleBoneStream, cmd)
    allcmds = (true, Int32(1), cmd)
    println("Sending single command: $allcmds")
    serialize(stream, allcmds)
    return
end
function read(bbstream::BeagleBoneStream, cmd)
    cmd, stream = safe_getreadcommand(dev)
    allcmds = (false, Int32(1), cmd)
    println("Sending single command: $allcmds")
    serialize(stream, allcmds)
    #TODO get, wait for and return response
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
