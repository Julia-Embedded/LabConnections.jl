"""
Lowest form of communication with the GPIO pins. The available pins are
listed in the "channel" parameter, and appear as directories in /sys/class/gpio.

Any of these GPIOs can be run in various ways, with any operation specified by an
Int32 value.

For instance, to setup a GPIO on "gpio112", configure it as an output pin and set
it to high, the following code would be used.

gpio = GPIO(1)
write!(gpio, (2,"out"))
write!(gpio, (1, "1"))

The operation of reading the current output value of the GPIO is done by

read(gpio, 1)

"""
type GPIO <: IO_Object
  i::Int32
  filestreams::Array{IOStream,1} #1 = value, 2 = direction, 3 = edge
  function GPIO(i::Int32)
    (i <= 0 || i > length(channels)) && error("Invalid GPIO index: $i")
    #TODO, in the future we should interface to config and let it setup gpio-folder and streams.
    #TODO: Add a write to export-file
    value_filestream = open("/sys/class/gpio/$(channels[i])/value","r+")
    direction_filestream = open("/sys/class/gpio/$(channels[i])/direction","r+")
    edge_filestream = open("/sys/class/gpio/$(channels[i])/edge","r")
    return new(i, [value_filestream, direction_filestream, edge_filestream])
  end
end

writeOperations = [["1", "0"],["in", "out"],["none","rising","falling","both"]]

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

"""
  write!(gpio::GPIO, args::Tuple{Int32,String}, debug::Bool=false)
Writes an entry to an operation on a GPIO, of the form args = (operation, entry).
"""
function write!(gpio::GPIO, args::Tuple{Int32,String}, debug::Bool=false)
  debug && return
  operation, entry = args[1], args[2]
  (operation < 1 || operation > length(gpio.filestreams)) && error("Invalid GPIO operation: $operation")
  if entry in writeOperations[operation]
    write(gpio.filestreams[operation], entry)
    seekstart(gpio.filestreams[operation])
  else
    error("Invalid entry for GPIO operation $operation: $entry")
  end
end

"""
  l = read(gpio::GPIO, operation::Int32, debug::Bool=false)
Reads the current value from an operation on a GPIO.
"""
function read(gpio::GPIO, operation::Int32, debug::Bool=false)
  debug && return
  (operation < 1 || operation > length(gpio.filestreams)) && error("Invalid GPIO operation: $operation")
  l = readline(gpio.filestreams[operation])
  seekstart(gpio.filestreams[operation])
  return l
end

"""
  teardown!(gpio::GPIO)
Closes all open streams on the GPIO, and unexports it from the file system.
"""
function teardown!(gpio::GPIO, debug::Bool=false)
  debug && return
  #Close all IOStreams
  for stream in gpio.filestreams
    close(stream)
  end
  #Unexport filestructure
  filename = "/sys/class/gpio/unexport"
  #TODO Verify if this is the correct command to send to unexport...
  write(filename, channels[gpio.i])
end
