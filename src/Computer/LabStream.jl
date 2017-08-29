export LabStream

abstract type LabStream end

function close(stream::LabStream)
    for dev in stream.devices
        close(dev)
    end
    close(stream.stream)
    return
end
