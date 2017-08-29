export AnalogInput10V, AnalogOutput10V

mutable struct AnalogInput10V <: AbstractDevice
    i::Int32
    stream::LabStream
    AnalogInput10V(i::Int32) = new(i)
end
mutable struct AnalogOutput10V <: AbstractDevice
    i::Int32
    stream::LabStream
    AnalogOutput10V(i::Int32) = new(i)
end
AnalogInput10V(i::Int64) = AnalogInput10V(convert(Int32, i))
AnalogOutput10V(i::Int64) = AnalogOutput10V(convert(Int32, i))

initialize(::AnalogInput10V) = nothing
initialize(::AnalogOutput10V) = nothing

close(::AnalogInput10V) = nothing
close(input::AnalogOutput10V) = ccall((:comedi_write_zero, comedipath), Void, (Int32, Int32, Int32), Int32(0), Int32(1), input.i)

getwritecommand(stream::LabStream, input::AnalogInput10V, val) = error("Can't write to device $input")
getreadcommand(stream::LabStream, output::AnalogOutput10V, val) = error("Can't read from device $output")

function getwritecommand(stream::BeagleBoneStream, input::AnalogOutput10V, val::Float64)
    abs(val) <= 10 || error("Volatage $val not in range [-10,10]")
    return ("analogin10", input.i, val)
end
function getreadcommand(stream::BeagleBoneStream, input::AnalogInput10V)
    return ("analogin10", input.i, val)
end

function getwritecommand(stream::ComediStream, input::AnalogOutput10V, val::Float64)
    abs(val) <= 10 || error("Volatage $val not in range [-10,10]")
    return (Int32(0),Int32(1),input.i,val)
end
function getreadcommand(stream::ComediStream, input::AnalogInput10V)
    return (Int32(0),Int32(0),input.i)
end
