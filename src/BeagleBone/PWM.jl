"""
This script allows for low level PWM control of selected pins
The valid pins dictionary relates to memory adresses in of the
AM3359 chip, see p.182 in

    www.ti.com/product/AM3359/technicaldocuments
"""

type PWM <: IO_Object
    i::Int32
    pin::String
    chip::String
    filestreams::Array{IOStream,1}
    function PWM(i::Int32)
        pins = collect(keys(validPins))
        (i < 1 || i > length(pins)) && error("Invalid PWM index: $i")
        pin = pins[i]

        # Configure the pin to run PWM if possible
        Base.run(`config-pin $(pin) pwm`)

        # Find chip and export number
        chip = validPins[pin][2]
        filename = "/sys/class/pwm/$(chip)/export"
        exportNumber = validPins[pin][3]

        # Export the filestructure of the corresponding chip
        write(filename, exportNumber)

        # Setup filestreams
        enable_filestream = open("/sys/class/pwm/$(validPins[pin][2])/pwm$(validPins[pin][3])/enable","r+")
        period_filestream = open("/sys/class/pwm/$(validPins[pin][2])/pwm$(validPins[pin][3])/period","r+")
        duty_cycle_filestream = open("/sys/class/pwm/$(validPins[pin][2])/pwm$(validPins[pin][3])/duty_cycle","r+")
        polarity_filestream = open("/sys/class/pwm/$(validPins[pin][2])/pwm$(validPins[pin][3])/polarity","r+")
        return new(i, pin, chip, [enable_filestream, period_filestream, duty_cycle_filestream, polarity_filestream])
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

    #TODO: Add a list of allowed entries for error checking
    write(pwm.filestreams[operation], entry)
    seekstart(pwm.filestreams[operation])
end

"""
  l = read(pwm::PWM, operation::Int32, debug::Bool=false)
Reads the current value from an operation on a PWM.
"""
function read(pwm::PWM, operation::Int32, debug::Bool=false)
  debug && return
  (operation < 1 || operation > length(pwm.filestreams)) && error("Invalid PWM operation: $operation")
  l = readline(pwm.filestreams[operation])
  seekstart(pwm.filestreams[operation])
  return l
end

"""
    teardown!(pwd::PWM)
Closes all open streams on the PWM, and unexports it from the file system
"""
function teardown!(pwm::PWM, debug::Bool=false)
        debug && return

        #Close all IOStreams
        for stream in pwm.filestreams
            close(stream)
        end

        #Unexport filestructure
        filename = "/sys/class/pwm/$(pwm.chip)/unexport"
        export_number = validPins[pwm.pin][3]
        write(filename, export_number)
    return
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
