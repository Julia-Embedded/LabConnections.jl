"""
    SysLED
Type representing the system LEDs on the BeagleBone. The LEDs are indexed by
i ∈ [1,2,3,4].
"""
type SysLED <: IO_Object
    i::Int32
    brightness_filestream::IOStream
    function SysLED(i::Int32)
        i ∉ [1,2,3,4] && error("Invalid SysLED index: $i")
        #Note, in the future we should interface to config and retrieve IOStream from there
        brightness_filestream = open("/sys/class/leds/beaglebone:green:usr$(i-1)/brightness","r+")
        return new(i, brightness_filestream)
    end
end

"""
    write!(led::SysLED, val::Bool, debug::Bool=false)
Turns the LED 'SysLed' on/off for val = true/false respectively.
"""
function write!(led::SysLED, val::Bool, debug::Bool=false)
    debug && return
    write(led.brightness_filestream, val ? "1" : "0")
    seekstart(led.brightness_filestream)
end

"""
    l = read(led::SysLED, debug::Bool=false)
Reads the current brightness value from the LED 'SysLED'.
"""
function read(led::SysLED, debug::Bool=false)
    debug && return
    l = read(led.brightness_filestream, Char)
    (l != '1' && l != '0') && error("Invalid value \"$l\" read from SysLed")
    seekstart(led.brightness_filestream)
    return l
end

"""
    teardown(led::SysLED, debug::Bool=false)
Closes all open filestreams for the SysLED 'led'.
"""
function teardown(led::SysLED, debug::Bool=false)
    debug && return
    close(led.brightness_filestream)
end
