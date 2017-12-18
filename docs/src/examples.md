# Examples on the BB
The following examples may be run from the BB, and may require the user to
export the the LabConnections module to the LOAD_PATH manually, executing the
following line in the Julia prompt

    push!(LOAD_PATH, "/home/debian/juliapackages")

When running the examples with hardware in the loop, take caution not to short
the BB ground with any output pin, as this will damage the board. For instance,
if connecting a diode to the output pins, always use a resistor of >1000 Ohm in
parallel. See the configuration page for information on which functionality
specific pins support.

```@contents
Pages = ["examples.md"]
Depth = 3
```

## Example with LEDs (BB)
To test the system LED functionality of the Julia code from the BBB, open a
Julia prompt and run the SYS_LED_test.jl file

    include("/home/debian/juliapackages/LabConnections/test/BeagleBone/SYS_LED_test.jl")

This example runs a test with hardware in the loop, exporting and unexporting
the SYS_LED devices and blinking led D2-D5 in a sequence over 1 second,
alternating with D2/D4 and D3/D5 on/off.

## Example with GPIOs (BB)
To test the GPIO functionality of the Julia code from the BBB, open a
Julia prompt and run the GPIO_test.jl file

    include("/home/debian/juliapackages/LabConnections/test/BeagleBone/GPIO_test.jl")

This again runs the tests with the BBB in the loop, testing exception handling
exporting of the file system and also runs all the GPIOs on the board high/low
at a 0.1 period time over 1 second to demonstrate the IO communication visually.

## Example with PWM (BB)
To test the PWM functionality of the Julia code from the BBB, open a
Julia prompt and run the PWM_test.jl file

    include("/home/debian/juliapackages/LabConnections/test/BeagleBone/PWM_test.jl")

This runs the PWM tests with the BBB in the loop, testing exception handling
exporting of the file system. In addition, it runs all the PWM pins on the board
with a duty cycle of 0.5 over a period time over 1 second to demonstrate the IO
communication visually.

## Example with SPI (BB)
All development on the SPI is currently done in C in a for of the serbus
package. Consequently, this example is currently run completely separate
from the LabConnections.

Make sure that the serbus package exists in the /juliapackages/ directory, where
it is automatically placed when transferring code to the BB using the ./flash_BB
shell script. Then simply run

    cp /home/debian/juliapackages/serbus/bb_spi.sh /home/debian

and execute

    ./bb_spi.sh

in the /home/debian/ directory. The program then
1) Compiles a device tree overlay (should SPI1 be used)
2) Creates the binaries for the SPI driver and example
3) Runs the MCP3903 example script located in spi_MCP3903.c

The purpose of the program is to configure the ADC to operate in the continuous
mode and then read the registers, outputting the measurements in the terminal.

## Example with LEDs (HOST)
To operate the LEDs from the host computer, simply connect the BBB to the HOST
via USB and run the "testLED.jl" on the HOST

    cd && cd .julia/v0.6/LabConnections/Examples/ && julia testLED.jl

```@systemConfiguration
```
