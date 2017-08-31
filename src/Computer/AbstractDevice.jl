export initialize, getstream, setstream!, send

###### Defaults for AbstractDevice
#What to do when connecting
initialize(::AbstractDevice) = nothing
#What to do when disconnecting
close(::AbstractDevice) = nothing
#Which stream is the AbstractDevice connected to
getstream(dev::AbstractDevice) = dev.stream
#Set the stream the AbstractDevice is connected to
setstream!(dev::AbstractDevice, stream::LabStream) = dev.stream = stream


function safe_getwritecommand(dev::AbstractDevice, val)
    stream = try getstream(dev) catch
        error("Device $dev not connected to a stream")
    end
    cmd = try getwritecommand(stream, dev, val) catch
        error("Device $dev with output val $val not supported on stream $stream")
    end
    return cmd, stream
end
function safe_getreadcommand(dev::AbstractDevice)
    stream = try getstream(dev) catch
        error("Device $dev not connected to a stream")
    end
    cmd = try getreadcommand(stream, dev) catch
        error("Device $dev not supported  to read from on stream $stream")
    end
    return cmd, stream
end

function send(dev::AbstractDevice, val)
    cmd, stream = safe_getwritecommand(dev, val)
    send(stream, cmd)
    return
end
function read(dev::AbstractDevice)
    cmd, stream = safe_getreadcommand(dev)
    vals, ts = read(stream, cmd)
    return vals
end

function put!(dev::AbstractDevice, val)
    cmd, stream = safe_getwritecommand(dev, val)
    push!(stream.sendbuffer,cmd)
    return
end

function get(dev::AbstractDevice)
    cmd, stream = safe_getreadcommand(dev)
    push!(stream.readbuffer,cmd)
    return
end
