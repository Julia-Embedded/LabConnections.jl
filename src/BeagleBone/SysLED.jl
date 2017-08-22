"""
The on-board leds with id ∈ [1,2,3,4]
"""
struct SysLED
end

function write!(::SysLED, ind::Int32, val::Bool)
    ind ∉ [1,2,3,4] && error("Invalid SysLEND ind: $ind")
    filename = "/sys/class/leds/beaglebone:green:usr$(ind-1)"
    file = open(filename, "w+")
    write(file, val ? "1" : "0")
    close(file)
    return
end
function read(::SysLED, ind::Int32)
    ind ∉ [1,2,3,4] && error("Invalid SysLEND ind: $ind")
    filename = "/sys/class/leds/beaglebone:green:usr$(ind-1)"
    file = open(filename, "r")
    l = readline(file, val)
    (l != "1" && l != "0") && error("Invalid value \"$l\" read from SysLed")
    close(file)
    return l == "1"
end
