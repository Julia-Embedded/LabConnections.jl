"""
Define abstract type for pins/LEDS on the BeagleBone
"""
abstract type IO_Object end

const gpio_operations = [
  ["1", "0"],
  ["in", "out"],
  ["none","rising","falling","both"]
]
const gpio_channels =[
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

# These pins are exported with the Device Tree Overlay cape-universaln (default)
const pwm_pins = Dict(
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
