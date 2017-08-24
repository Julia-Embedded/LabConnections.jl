abstract type LabStream end
abstract type Device end

include("Device.jl")

##### General interface for LabStream
## A stream of type T <: LabStream should define the methods
# serialize(::T, cmd)                   # Send data `cmd`
# init_devices!(::T, devs::Device...)   # Initialize devices and connect them to stream
# send!(::T)                            # Send set! commands for all devices to stream, using getwritecommand(stream::LabStream, dev::Device, getsetvalue(dev::Device))
# read(::T)                             # Send read commands for all devices to stream, sing get(dev::Device)
# init_devices!                         # Initialize all connected devises, using initialize(::Device)
# close                                # Close connection, call close(::Device) on all connected devices

#Include the stream definitions
include("BeagleBoneStream.jl")


##### General interface for devices
## A device to type T<:Device should define the methods
# set!(dev::T, val)    # Remember val for next send!(::LabStream) command
# getsetvalue(dev::T)  # Get the value that was saved to send
# get(dev::T)          # Get val from last next read(::LabStream) command

# getwritecommand(stream::LabStream, dev::T, val)   #Get canonlical representation of send command
# getreadcommand(stream::LabStream, dev::T)         #Get canonlical representation of read command

## Default methods:
# initialize(::Device) = nothing    #What to do when initializing
# close(::Device) = nothing          #What to do when disconnecting
# getstream(dev::Device) = dev.stream #Which stream is the Device connected to
# setstream!(dev::Device, stream::LabStream) = dev.stream = stream #Set the stream the Device is connected to
##### END General interface for devices

#Include the device definitions
include("SysLED.jl")
