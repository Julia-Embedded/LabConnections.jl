"""
Lowest form of communication with the GPIO pins. The available pins are
listed in the "channel" parameter, and appear as directories in /sys/class.

Any of these GPIOs can be run in various ways, with any operation specified
by a sequence of three entries

  (channel, (operation, entry)) = (int32, (String, String))

For instance, if the GPIO "gpio30" is to be configured as a output pin and set
to high, the following two writes would be done.

  write!(GPIO, 14, ("direction", "out"))
  write!(GPIO, 14, ("value", "1"))

The operation of reading the current cofiguration of the GPIO is specified by

  (channel, operation) = (int32, String)

For instance, to read the current value of the GPIO "gpio30" the following read
would be done

  read(GPIO, 14, "value")

"""
struct GPIO
end

writeOperations = Dict("value" => ["1", "0"], "direction" => ["in", "out"])

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

function write!(::GPIO, index::Int32, args::Tuple{String,String}, debug::Bool=false)
    debug && return
    operation, entry = args[1], args[2]
    (index <= 0 || index > length(channels)) && error("Invalid GPIO index: $index")
    !haskey(writeOperations,operation) && error("Invalid GPIO operation: $operation")
    filename = "/sys/class/gpio/$(channels[index])/$operation"

    if entry in writeOperations[operation]
        file = open(filename, "r+")
        write(file, "$(entry)")
        close(file)
    else
        error("Cannot write $(entry) to operation: $operation")
    end
    return
end

function read(::GPIO, index::Int32, operation::String, debug::Bool=false)
    debug && return
    (index <= 0 || index > length(channels)) && error("Invalid GPIO index: $index")

    if operation in readOperations
      filename = "/sys/class/gpio/$(channels[index])/$operation"
      file = open(filename, "r")
      l = readline(file)
      close(file)
      l ∉ readOperations[operation] && error("Invalid entry read : $l")
      return l
    else
      error("Cannot read from: $operation")
    end
end
