mutable struct SysLED <: Device
    i::Int32
    nextout::Bool
    latestread::Bool
    stream::LabStream
    SysLED(i::Int32) = new(i, false, false)
end
SysLED(i::Int64) = SysLED(convert(Int32, i))

#Save value to send later
set!(led::SysLED, val::Bool) = led.nextout = val
#Get the value from set! back for use
getsetvalue(led::SysLED) = led.nextout
#Get value that was read erlier
Base.get(led::SysLED) = led.latestread

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
