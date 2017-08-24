export initialize, getstream, setstream!, send!, set!, getsetvalue

###### Defaults for Device
#What to do when connecting
initialize(::Device) = nothing
#What to do when disconnecting
close(::Device) = nothing
#Which stream is the Device connected to
getstream(dev::Device) = dev.stream
#Set the stream the Device is connected to
setstream!(dev::Device, stream::LabStream) = dev.stream = stream


function safe_getwritecommand(dev::Device, val)
    stream = try getstream(dev) catch
        error("Device $dev not connected to a stream")
    end
    cmd = try getwritecommand(stream, dev, val) catch
        error("Device $dev with output val $val not supported on stream $stream")
    end
    return cmd, stream
end
function safe_getreadcommand(dev::Device)
    stream = try getstream(dev) catch
        error("Device $dev not connected to a stream")
    end
    cmd = try getreadcommand(stream, dev) catch
        error("Device $dev not supported  to read from on stream $stream")
    end
    return cmd, stream
end

#Maybe rethink a bit to support IObox
function send!(dev::Device, val)
    cmd, stream = safe_getwritecommand(dev, val)
    #TODO This is not very general
    allcmds = (true, Int32(1), cmd)
    println("Sending single command: $allcmds")
    serialize(stream, allcmds)
    return
end
function read(dev::Device)
    cmd, stream = safe_getreadcommand(dev)
    allcmds = (false, Int32(1), cmd)
    println("Sending single command: $allcmds")
    serialize(stream, allcmds)

    #TODO get, wait for and return response
    return
end
