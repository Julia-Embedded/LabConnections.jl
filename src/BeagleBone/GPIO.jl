"""
Lowest form of communication woth the GPIO pins. The available pins are
listed in the "channel" parameter, and appear as directories in /sys/class.
Any of these GPIOs can be run in various ways, with any operation specified
by a sequence of three entries

  (channel, operation, entry) = (int32, int32, String)

For instance, if the GPIO "gpio30" is to be configured as a output pin and set
to high, the following two writes aould be done.

  write!(GPIO, 14, 2, "out")
  write!(GPIO, 14, 1, "1")

"""
struct GPIO
end

writeOperations = [
    Dict("dir" => "value",     "entries"=>["1", "0"])
    Dict("dir" => "direction", "entries"=>["in", "out"])
]

readOperations = [
    "value"
    "direction"
    "edge"
]

channels =[
    "gpio112"
    "gpio114"
    "gpio115"
    "gpio116"
    "gpio14"
    "gpio15"
    "gpio2"
    "gpio20"
    "gpio22"
    "gpio23"
    "gpio26"
    "gpio27"
    "gpio3"
    "gpio30"
    "gpio31"
    "gpio4"
    "gpio44"
    "gpio45"
    "gpio46"
    "gpio47"
    "gpio48"
    "gpio49"
    "gpio5"
    "gpio50"
    "gpio51"
    "gpio60"
    "gpio61"
    "gpio65"
    "gpio66"
    "gpio67"
    "gpio68"
    "gpio69"
    "gpio7"
]

function write!(::GPIO, index::Int32, operation::Int32, entry::Bool)
    (index <= 0 || index > length(channels)) && error("Invalid GPIO index: $index")
    (operation <= 0 || operation > length(writeOperations)) && error("Invalid GPIO operation: $operation")
    filename = "/sys/class/gpio/$(channels[index])/$(writeOperations[operation]["dir"])"

    value = writeOperations[operation]["entries"][entry ? 1 : 2]
    file = open(filename, "r+")

    write(file, "$(value)")
    close(file)
    return
end

#function Base.read(::SysLED, ind::Int32)
#    (ind < 0 || ind > length(channels)) && error("Invalid SysLEND ind: $ind")
#    println("not yet supported")
#    l = 0
#    return l == "1"
#end
