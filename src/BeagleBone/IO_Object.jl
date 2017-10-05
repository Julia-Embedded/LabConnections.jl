"""
Define abstract type for pins/LEDS on the BeagleBone
"""
abstract type IO_Object end

"""
GPIO interfaces
"""
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
