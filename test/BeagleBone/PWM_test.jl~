include("../../src/LabConnection.jl")
using LabConnection.BeagleBone
import LabConnection.BeagleBone: getdev, write!, setup, teardown

pins = Dict(
    "P9.22" => ("PWM0A", "pwmchip0", "0"),
    "P9.21" => ("PWM0B", "pwmchip0", "1"),
    "P9.14" => ("PWM1A", "pwmchip0", "0"),
    "P9.16" => ("PWM1B", "pwmchip0", "1"),
    "P8.19" => ("PWM2A", "pwmchip0", "0"),
    "P8.13" => ("PWM2B", "pwmchip0", "1"),
)

dev = getdev("pwm")

println("Running first experiment on selected pins...")
for pin in keys(pins)
    println("Testing pin $(pin)")
    setup(dev, pin)
    write!(dev, pin, 2, "100000000")
    write!(dev, pin, 3, "50000000")
    write!(dev, pin, 1, "1")
    sleep(1)
    write!(dev, pin, 1, "0")
    teardown(dev, pin)
end


println("Running second experiment on pin $(pin)...")
pin = "P9.22"
setup(dev, pin)
write!(dev, pin, 2, "1000000000")
write!(dev, pin, 3, "250000000")
write!(dev, pin, 1, "1")
sleep(5.0)
write!(dev, pin, 3, "500000000")
sleep(5.0)
write!(dev, pin, 3, "750000000")
write!(dev, pin, 1, "0")
teardown(dev, pin)
