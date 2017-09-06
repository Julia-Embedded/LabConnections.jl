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
    filestreams::Array{IOStream,1} #1 = enable, 2 = period, 3 = duty_cycle, 4 = polarity
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

# These pins are exported with the Device Tree Overlay cape-universaln (default)
validPins = Dict(
    "P9.22" => ("PWM0A", "pwmchip0", "0"),
    "P9.21" => ("PWM0B", "pwmchip0", "1"),
    "P9.14" => ("PWM1A", "pwmchip2", "0"),
    "P9.16" => ("PWM1B", "pwmchip2", "1"),
    "P8.19" => ("PWM2A", "pwmchip4", "0"),
    "P8.13" => ("PWM2B", "pwmchip4", "1"),
)

# These pins are exported with the Device Tree Overlay cape-universala
#    "P8.36" => ("PWM1A", "pwmchip1", "0"),
#    "P9.29" => ("PWM0B", "pwmchip0", "1"),
#    "P8.46" => ("PWM2B", "pwmchip2", "1")
#    "P8.45" => ("PWM2A", "pwmchip2", "0"),
#    "P8.34" => ("PWM1B", "pwmchip1", "1"),
#    "P9.31" => ("PWM0A", "pwmchip0", "0"),

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
