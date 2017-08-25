"""
This script allows for low level PWM control of selected pins
The valid pins dictionary relates to memory adresses in of the
AM3359 chip, see p.182 in

    www.ti.com/product/AM3359/technicaldocuments
"""

struct PWM
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

function setup(::PWM, pin::String)
    if pin in keys(validPins)

        # Configure the pin to run PWM if possible
        Base.run(`config-pin $(pin) pwm`)

        # Find chip and export number
        chip = validPins[pin][2]
        filename = "/sys/class/pwm/$(chip)/export"
        exportNumber = validPins[pin][3]

        # Export the filestructure of the corresponding chip
        write(filename, exportNumber)
    else
        error("The pin write $(pin) does not support PWM")
    end
    return
end

function teardown(::PWM, pin::String)
    if pin in keys(validPins)
        # Find chip and export number
        chip = validPins[pin][2]
        filename = "/sys/class/pwm/$(chip)/unexport"
        exportNumber = validPins[pin][3]
        
        # Export the filestructure of the corresponding chip
        write(filename, exportNumber)
    else
        error("The pin write $(pin) does not support PWM")
    end
    return
end

function write!(::PWM, pin::String, operation::Int32, entry::String)
    !(pin in keys(validPins)) && error("Invalid PWM pin: $(pin))")
    (operation <= 0 || operation > 4) && error("Invalid GPIO operation: $operation")

    # TODO: Error checks
    if operation == 1
        directory = "enable"

    end
    if operation == 2
        directory = "period"

    end
    if operation == 3
        directory = "duty_cycle"

    end
    if operation == 4
        directory = "polarity"

    end

    filename = "/sys/class/pwm/$(validPins[pin][2])/pwm$(validPins[pin][3])/$(directory)"
    file = open(filename, "r+")
    write(file, "$(entry)")
    close(file)
    return
end
