"""
    GPIO(i::Int32)
Lowest form of communication with the GPIO pins. The available pins are
listed in the "channel" parameter, and appear as directories in /sys/class/gpio
after being exported. For instance, to setup a GPIO on "gpio112", configure it as an output pin and set
it to high, the following code would be used.

    `gpio = GPIO(1)`
    `write!(gpio, (2,"out"))`
    `write!(gpio, (1, "1"))`

The operation of reading the current output value of the GPIO is done by

    `read(gpio, 1)`

See the test/BeagleBone/GPIO_test.jl for more examples.
"""
type GPIO <: IO_Object
  i::Int32
  basedir::String
  filestreams::Array{IOStream,1}
  function GPIO(i::Int32)
    (i <= 0 || i > length(gpio_channels)) && error("Invalid GPIO index: $i")

    # If the tests re being run, a dummy filesystem is created
    basedir = export_gpio(i)

    # setup IOstreams
    value_filestream = open("$(basedir)/$(gpio_channels[i])/value","r+")
    direction_filestream = open("$(basedir)/$(gpio_channels[i])/direction","r+")
    edge_filestream = open("$(basedir)/$(gpio_channels[i])/edge","r")

    # Initialize object
    return new(i, basedir, [value_filestream, direction_filestream, edge_filestream])
  end
end

"""
    write!(gpio::GPIO, args::Tuple{Int32,String}, debug::Bool=false)
Writes an entry to an operation on a GPIO, of the form args = (operation, entry).
"""
function write!(gpio::GPIO, args::Tuple{Int32,String}, debug::Bool=false)
  debug && return
  operation, entry = args[1], args[2]
  # Only filestreams 1 and 2 are writable
  operation ∉ [1,2] && error("Invalid GPIO operation $operation for writing")
  if entry in gpio_operations[operation]
    seekstart(gpio.filestreams[operation])
    write(gpio.filestreams[operation], "$entry\n")
    flush(gpio.filestreams[operation])
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
  # Filestreams 1, 2 and 3 are readable
  operation ∉ [1,2,3] && error("Invalid GPIO operation: $operation for reading")
  seekstart(gpio.filestreams[operation])
  l = readline(gpio.filestreams[operation])
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
      rm("$(gpio.basedir)/$(gpio_channels[gpio.i])"; recursive=true)
    catch
      error("Could not remove the requested GPIO testfiles for channel $(gpio_channels[i]).")
    end
  else
    # Remove the file system
    filename = "/sys/class/gpio/unexport"
    #TODO Verify if this is the correct command to send to unexport
    write(filename, gpio_channels[gpio.i])
  end
end

"""
    export_gpio(i::Int32, debug::Bool=false)
Export the GPIO file system, either for real-time or testing usecases.
"""
function export_gpio(i::Int32)
  if isdefined(:RUNNING_TESTS)
    # Export a dummy file system for testing
    basedir = "$(pwd())/testfilesystem/gpio"
    try
      #println("$(basedir)/$(gpio_channels[i])")
      mkpath("$(basedir)/$(gpio_channels[i])")
    catch
      error("Could not export the GPIO device for channel $(gpio_channels[i]) for testing as the directory $(basedir)/$(gpio_channels[i]) already exists.")
    end
    try
      f = open("$(basedir)/$(gpio_channels[i])/value", "w"); write(f,"0"); close(f);
      f = open("$(basedir)/$(gpio_channels[i])/direction", "w"); write(f,"0"); close(f);
      f = open("$(basedir)/$(gpio_channels[i])/edge", "w"); write(f,"0"); close(f);
    catch
      error("Could not open the requested GPIO testfiles for channel $(gpio_channels[i]).")
    end
  else
    basedir = "/sys/class/gpio"
    # TODO Export for real-time use
  end
  return basedir
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
