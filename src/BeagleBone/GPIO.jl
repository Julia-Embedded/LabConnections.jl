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
  basedir::String
  filestreams::Array{IOStream,1}
  function GPIO(i::Int32)
    (i <= 0 || i > length(channels)) && error("Invalid GPIO index: $i")

    # If the tests re being run, a dummy filesystem is created
    if isdefined(:RUNNING_TESTS)
      # Export a dummy file system for testing
      basedir = "$(pwd())/testfilesystem/gpio"
      try
        println("$(basedir)/$(channels[i])")
        mkpath("$(basedir)/$(channels[i])")
      catch
        error("Could not export the GPIO device for channel $(channels[i]) for testing as the directory $(basedir)/$(channels[i]) already exists.")
      end
      try
        f = open("$(basedir)/$(channels[i])/value", "w"); write(f,"0"); close(f);
        f = open("$(basedir)/$(channels[i])/direction", "w"); write(f,"0"); close(f);
        f = open("$(basedir)/$(channels[i])/edge", "w"); write(f,"0"); close(f);
      catch
        error("Could not open the requested GPIO testfiles for channel $(channels[i]).")
      end
    else
      basedir = "/sys/class/gpio"
      # TODO Export for real-time use
    end

    # setup IOstreams
    value_filestream = open("$(basedir)/$(channels[i])/value","r+")
    direction_filestream = open("$(basedir)/$(channels[i])/direction","r+")
    edge_filestream = open("$(basedir)/$(channels[i])/edge","r")

    # Initialize object
    return new(i, basedir, [value_filestream, direction_filestream, edge_filestream])
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
    error("Invalid entry for GPIO operation $(operation): $(entry)")
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
  teardown(gpio::GPIO, debug::Bool=false)
Closes all open streams on the GPIO, and unexports it from the file system.
"""
function teardown(gpio::GPIO, debug::Bool=false)
  debug && return

  #Close all IOStreams
  for stream in gpio.filestreams
    close(stream)
  end

  #Unexport filestructure
  if isdefined(:RUNNING_TESTS)
    # Remove the dummy file system for testing
    basedir = "$(pwd())/testfilesystem/gpio"
    try
      rm("$(gpio.basedir)/$(channels[gpio.i])"; recursive=true)
    catch
      error("Could not remove the requested GPIO testfiles for channel $(channels[i]).")
    end
  else
    # Remove the file system
    filename = "/sys/class/gpio/unexport"
    #TODO Verify if this is the correct command to send to unexport...
    write(filename, channels[gpio.i])
  end
end

"""
  to_string(gpio::GPIO, debug::Bool=false)
Generates a string representation of the GPIO device.
"""
function to_string(gpio::GPIO, debug::Bool=false)
  debug && return
  message = "\nID: $(gpio.i)\n\nAvailable filestreams:\n"
  for ii = 1:length(gpio.filestreams)
    message = string(message, "  index=$(ii) - name=$(gpio.filestreams[ii].name) - write/read=$(iswritable(gpio.filestreams[ii]))/$(isreadable(gpio.filestreams[ii]))\n")
  end
  return message
end
