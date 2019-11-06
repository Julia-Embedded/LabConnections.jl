export GPIO

const GPIO_VALUE = Int32(1)
const GPIO_DIRECTION = Int32(2)
const GPIO_EDGE = Int32(3)
"""
GPIO(i::Integer, direction:Bool)
direction = true if output (write)
direction = false if input (read)

"""
mutable struct GPIO <: AbstractDevice
    i::Int32
    direction::Bool
    stream::LabStream
    GPIO(i::Int32, direction::Bool) = new(i, direction)
end
GPIO(i::Integer, direction::Bool) = GPIO(convert(Int32, i), direction)

function getsetupwrite(stream::BeagleBoneStream, gpio::GPIO)
    if gpio.direction
        return ("gpio", gpio.i, (GPIO_DIRECTION, "out"))
    else
        return ("gpio", gpio.i, (GPIO_DIRECTION, "in"))
    end
end

#Stream specific methods
function getwritecommand(stream::BeagleBoneStream, gpio::GPIO, val::Bool)
    if !gpio.direction
        error("Can not write to GPIO input (read) device")
    end
    # TODO Check valid GPIO index
    return ("gpio", gpio.i, (GPIO_VALUE, val ? "1" : "0"))
end
function getreadcommand(stream::BeagleBoneStream, gpio::GPIO)
    # TODO Check valid GPIO index
    return ("gpio", gpio.i)
end
