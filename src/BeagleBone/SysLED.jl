"""
    SysLED(i::Int32)
Type representing the system LEDs on the BeagleBone. The LEDs are indexed by
i ∈ [1,2,3,4].
"""
struct SysLED <: IO_Object
    i::Int32
    basedir::String
    filestream::IOStream
    function SysLED(i::Int32)
        i ∉ [1,2,3,4] && error("Invalid SysLED index: $i")

        # Export system for testing
        basedir = export_led(i)

        # open filestream
        brightness_filestream = open("$(basedir)/beaglebone:green:usr$(i-1)/brightness","r+")
        return new(i, basedir, brightness_filestream)
    end
end

"""
    write!(led::SysLED, val::Bool, debug::Bool=false)
Turns the LED 'SysLed' on/off for val = true/false respectively.
"""
function write!(led::SysLED, entry::String, debug::Bool=false)
    debug && return
    entry ∉ ["0", "1"] && error("Invalid SysLED entry $(entry), valid options are 0 and 1 ::String")
    seekstart(led.filestream)
    write(led.filestream, "$entry\n")
    flush(led.filestream)
end

"""
    l = read(led::SysLED, debug::Bool=false)
Reads the current brightness value from the LED 'SysLED'.
"""
function read(led::SysLED, debug::Bool=false)
    debug && return
    seekstart(led.filestream)
    return readline(led.filestream)
end

"""
    teardown(led::SysLED, debug::Bool=false)
Closes all open filestreams for the SysLED 'led'.
"""
function teardown(led::SysLED, debug::Bool=false)
  debug && return
  close(led.filestream)

  global RUNNING_TESTS
  if RUNNING_TESTS
    # Remove the dummy file system for testing
    try
      #println("$(led.basedir)/beaglebone:green:usr$(led.i-1)")
      rm("$(led.basedir)/beaglebone:green:usr$(led.i-1)"; recursive=true)
    catch
      error("Could not remove the requested LED testfiles for channel beaglebone:green:usr$(led.i-1).")
    end
  end
end

"""
    export_led(i::Int32, debug::Bool=false)
Exports a dummy filesystem for testing the LED implementation
"""
function export_led(i::Int32, debug::Bool=false)
  debug && return

  global RUNNING_TESTS
  if RUNNING_TESTS
    # Export a dummy file system for testing
    basedir = "$(pwd())/testfilesystem/leds"
    try
      #println("$(basedir)/beaglebone:green:usr$(i-1)")
      mkpath("$(basedir)/beaglebone:green:usr$(i-1)")
    catch
      error("Could not export the LED device for beaglebone:green:usr$(i-1)) for testing as the directory $(basedir)/beaglebone:green:usr$(i-1) already exists.")
    end
    try
      f = open("$(basedir)/beaglebone:green:usr$(i-1)/brightness", "w"); write(f,"0"); close(f);
    catch
      error("Could not open the requested LED testfiles for beaglebone:green:usr$(i-1)/brightness.")
    end
  else
    basedir = "/sys/class/leds"
  end
  return basedir
end

"""
    to_string(led::SysLED, debug::Bool=false)
Generates a string representation of the GPIO device.
"""
function to_string(led::SysLED, debug::Bool=false)
  debug && return
  message = "\nID: $(led.i)\n\nAvailable filestream:\n"
  message = string(message, "  name=$(led.filestream.name) - write/read=$(iswritable(led.filestream))/$(isreadable(led.filestream))\n")
  return message
end
