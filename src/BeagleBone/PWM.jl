"""
    PWM()
This device allows for low level PWM control of selected pins. The valid pins
dictionary pwm_pins relates to memory adresses in of the AM3359 chip, see p.182
in www.ti.com/product/AM3359/technicaldocuments.
"""

type PWM <: IO_Object
    i::Int32
    pin::String
    chip::String
    basedir::String
    filestreams::Array{IOStream,1}
    function PWM(i::Int32)

        (i < 1 || i > length(pwm_pins)) && error("Invalid PWM index: $i")

        # Export the PWM pin
        basedir = export_pwm(i)

        # Setup filestreams
        pins = collect(keys(pwm_pins))
        pin = pins[i]
        chip = pwm_pins[pin][2]

        enable_filestream = open("$(basedir)/$(pwm_pins[pin][2])/pwm$(pwm_pins[pin][3])/enable","r+")
        period_filestream = open("$(basedir)/$(pwm_pins[pin][2])/pwm$(pwm_pins[pin][3])/period","r+")
        duty_cycle_filestream = open("$(basedir)/$(pwm_pins[pin][2])/pwm$(pwm_pins[pin][3])/duty_cycle","r+")
        polarity_filestream = open("$(basedir)/$(pwm_pins[pin][2])/pwm$(pwm_pins[pin][3])/polarity","r+")
        return new(i, pin, chip, basedir, [enable_filestream, period_filestream, duty_cycle_filestream, polarity_filestream])
    end
end

"""
    write!(pwm::PWM, args::Tuple{Int32,String}, debug::Bool=false)
Writes an entry to an operation on the PWM, of the form args = (operation, entry).
"""
function write!(pwm::PWM, args::Tuple{Int32,String}, debug::Bool=false)
    debug && return

    operation, entry = args[1], args[2]
    (operation < 1 || operation > length(pwm.filestreams)) && error("Invalid PWM operation: $operation")

    # Input data check
    assert_pwm_write(operation, entry)

    # Write to file
    seekstart(pwm.filestreams[operation])
    write(pwm.filestreams[operation], "$entry\n")
    flush(pwm.filestreams[operation])
end

"""
    assert_pwm_write(operation::Int32, entry::String)
Assertsion for the PWM input data
"""
function assert_pwm_write(operation::Int32, entry::String)
  if operation == "1"
    entry ∉ ["0", "1"] && error("Invalid SysLED entry $(entry), valid options are 0 and 1 ::String")
  else
    number = try
      parse(Int32, entry)
    catch
      error("Invalid SysLED entry $(entry), cannot parse as Int32")
    end
    (number < 0 || number > 100000000) && error("Invalid SysLED entry $(entry), not in the range [0,100000000]")
  end
end

"""
  l = read(pwm::PWM, operation::Int32, debug::Bool=false)
Reads the current value from an operation on a GPIO.
"""
function read(pwm::PWM, operation::Int32, debug::Bool=false)
  debug && return
  # Filestreams 1, 2 and 3 are readable
  operation ∉ [1,2,3,4] && error("Invalid GPIO operation: $operation for reading")
  seekstart(pwm.filestreams[operation])
  l = readline(pwm.filestreams[operation])
  return l
end




"""
    teardown!(pwd::PWM)
Closes all open streams on the PWM, and unexports it from the file system
"""
function teardown(pwm::PWM, debug::Bool=false)
  debug && return

  #Close all IOStreams
  for stream in pwm.filestreams
    close(stream)
  end

  if isdefined(:RUNNING_TESTS)
    # Remove the dummy file system for testing
    try
      rm("$(pwm.basedir)/$(pwm_pins[pwm.pin][2])/pwm$(pwm_pins[pwm.pin][3])"; recursive=true)
    catch
      error("Could not remove the requested GPIO testfiles for channel $(pwm_pins[pwm.pin][2])/pwm$(pwm_pins[pwm.pin][3]).")
    end
  else
    #Unexport filestructure
    filename = "/sys/class/pwm/$(pwm.chip)/unexport"
    export_number = pwm_pins[pwm.pin][3]
    write(filename, export_number)
  end
end

"""
  export_gpio(i::Int32, debug::Bool=false)
Export the GPIO file system, either for real-time or testing usecases.
"""
function export_pwm(i::Int32)
  # Find chip and export number
  pins = collect(keys(pwm_pins))
  pin = pins[i]
  chip = pwm_pins[pin][2]

  if isdefined(:RUNNING_TESTS)
    # Export a dummy file system for testing
    basedir = "$(pwd())/testfilesystem/pwm"
    complete_path = "$(basedir)/$(pwm_pins[pin][2])/pwm$(pwm_pins[pin][3])"
    try
      mkpath(complete_path)
    catch
      error("Could not export the PWM device for $(pwm_pins[pin][2]) for testing as the directory $(basedir)/$(pwm_pins[pin][2])/pwm$(pwm_pins[pin][3]) already exists.")
    end
    try
      f = open("$(complete_path)/enable", "w"); write(f,"0"); close(f);
      f = open("$(complete_path)/period", "w"); write(f,"0"); close(f);
      f = open("$(complete_path)/duty_cycle", "w"); write(f,"0"); close(f);
      f = open("$(complete_path)/polarity", "w"); write(f,"0"); close(f);
    catch
      error("Could not open the requested GPIO testfiles for $(complete_path).")
    end
  else
    basedir = "/sys/class/pwm"

    # Configure the pin to run PWM if possible
    Base.run(`config-pin $(pin) pwm`)

    # Export the filestructure of the corresponding chip
    filename = "/sys/class/pwm/$(chip)/export"
    exportNumber = pwm_pins[pin][3]
    write(filename, exportNumber)
  end
  return basedir
end

"""
  to_string(pwm::PWM,, debug::Bool=false)
Generates a string representation of the GPIO device.
"""
function to_string(pwm::PWM, debug::Bool=false)
  debug && return
  message = "\nID: $(pwm.i)\n\nAvailable filestreams:\n"
  for ii = 1:length(pwm.filestreams)
    message = string(message, "  index=$(ii) - name=$(pwm.filestreams[ii].name) - write/read=$(iswritable(pwm.filestreams[ii]))/$(isreadable(pwm.filestreams[ii]))\n")
  end
  return message
end
