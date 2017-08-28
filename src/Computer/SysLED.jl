export SysLED

mutable struct SysLED <: AbstractDevice
    i::Int32
    stream::LabStream
    SysLED(i::Int32) = new(i)
end
SysLED(i::Int64) = SysLED(convert(Int32, i))

#No definition for IOBox since there are no LEDs
#Stream specific methods
function getwritecommand(stream::BeagleBoneStream, led::SysLED, val::Bool)
    led.i ∉ Int32[1,2,3,4] && error("SysLED $i not defined on BeagleBoneStream")
    return ("sysled", led.i, val)
end
function getreadcommand(stream::BeagleBoneStream, led::SysLED)
    led.i ∉ Int32[1,2,3,4] && error("SysLED $i not defined on BeagleBoneStream")
    return ("sysled", led.i)
end
