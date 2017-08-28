export ComediStream, init_devices!

const comedipath = joinpath(@__DIR__,"comedi","comedi_bridge.so")
const comediname = "/dev/comedi0"
const SendTuple = Tuple{Int32,Int32,Int32,Float64}
const ReadTuple = Tuple{Int32,Int32,Int32}

struct ComediStream <: LabStream
    devices::Array{AbstractDevice,1}
    sendbuffer::Array{SendTuple,1}
    readbuffer::Array{ReadTuple,1}
end

function ComediStream()
    ccall((:comedi_start, comedipath),Int32,(Ptr{UInt8},), comediname)
    ComediStream(AbstractDevice[], SendTuple[], ReadTuple[])
end

function init_devices!(stream::ComediStream, devs::AbstractDevice...)
    for dev in devs
        if dev ∉ comedistream.devices
            setstream!(dev, comedistream)
            push!(comedistream.devices, dev)
            initialize(dev)
        else
            warn("Device $dev already added to the stream")
        end
    end
    return
end

function send(comedistream::ComediStream, cmd::SendTuple)
    ccall((:comedi_write, comedipath),Int32,(Int32,Int32,Int32,Float64), cmd[1], cmd[2], cmd[3], cmd[4])
    return
end
function read(comedistream::ComediStream, cmd::ReadTuple)
    ccall((:comedi_read, comedipath),Int32,(Int32,Int32,Int32), cmd[1], cmd[2], cmd[3])
    return
end

function send(comedistream::ComediStream)
    map(cmd -> send(comedistream, cmd), comedistream.sendbuffer)
    empty!(comedistream.readbuffer)
    return
end
function read(comedistream::ComediStream)
    vals = map(cmd -> read(comedistream, cmd), comedistream.sendbuffer)
    empty!(comedistream.readbuffer)
    return vals
end

function close(stream::ComediStream)
    foreach(close, stream.devices)
    ccall((:comedi_stop, comedipath),Int32,(Int32,), 0)
    return
end
