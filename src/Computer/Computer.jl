abstract type AbstractDevice end

include("LabStream.jl")
include("AbstractDevice.jl")

##### General interface for LabStream
## A stream of type T <: LabStream should define the methods
# serialize(::T, cmd)                   # Send data `cmd`
# init_devices!(::T, devs::AbstractDevice...)   # Initialize devices and connect them to stream
# send(::T)                            # Send set! commands for all devices to stream, using getwritecommand(stream::LabStream, dev::AbstractDevice, getsetvalue(dev::AbstractDevice))
# read(::T)                             # Send read commands for all devices to stream, sing get(dev::AbstractDevice)
# init_devices!                         # Initialize all connected devises, using initialize(::AbstractDevice)
# close                                # Close connection, call close(::AbstractDevice) on all connected devices

#Include the stream definitions
include("ComediStream.jl")
include("BeagleBoneStream.jl")


##### General interface for devices
## A device to type T<:AbstractDevice should define the methods
# set!(dev::T, val)    # Remember val for next send(::LabStream) command
# get(dev::T)          # Get val from last next read(::LabStream) command

# getwritecommand(stream::LabStream, dev::T, val)   #Get canonlical representation of send command
# getreadcommand(stream::LabStream, dev::T)         #Get canonlical representation of read command

## Default methods:
# initialize(::AbstractDevice) = nothing    #What to do when initializing
# close(::AbstractDevice) = nothing          #What to do when disconnecting
# getstream(dev::AbstractDevice) = dev.stream #Which stream is the Device connected to
# setstream!(dev::AbstractDevice, stream::LabStream) = dev.stream = stream #Set the stream the Device is connected to
##### END General interface for devices

#Include the device definitions
include("SysLED.jl")
include("GPIO.jl")
include("10V.jl")
