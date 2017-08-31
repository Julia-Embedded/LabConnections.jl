"""
The on-board leds with id ∈ [1,2,3,4]
"""
struct SysLED
end

function write!(::SysLED, ind::Int32, val::Bool, debug::Bool=false)
    debug && return
    ind ∉ [1,2,3,4] && error("Invalid SysLEND ind: $ind")
    filename = "/sys/class/leds/beaglebone:green:usr$(ind-1)/brightness"
    file = open(filename, "r+")
    write(file, val ? "1" : "0")
    close(file)
    return
end
function read(::SysLED, ind::Int32, debug::Bool=false)
    debug && return
    ind ∉ [1,2,3,4] && error("Invalid SysLEND ind: $ind")
    filename = "/sys/class/leds/beaglebone:green:usr$(ind-1)/brightness"
    file = open(filename, "r")
    l = read(file,Char)
    (l != '1' && l != '0') && error("Invalid value \"$l\" read from SysLed")
    close(file)
    return l == '1'
end
