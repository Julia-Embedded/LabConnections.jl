[![pipeline status](https://gitlab.control.lth.se/labdev/LabConnections.jl/badges/master/pipeline.svg)](https://gitlab.control.lth.se/labdev/LabConnections.jl/commits/master)
[![coverage report](https://gitlab.control.lth.se/labdev/LabConnections.jl/badges/master/coverage.svg)](https://gitlab.control.lth.se/labdev/LabConnections.jl/commits/master)

# Welcome to LabConnections.jl - the IO-software part of the LabDev project
<img src="docs/images/labio_overview.png" height="200" width="1050">

The goal of this project is to develop a software package in [Julia](https://julialang.org/) 
for interfacing with lab processes using either the [BeagleBone Black Rev C](http://beagleboard.org/) (BBB)
with custom [IO-board cape](https://gitlab.control.lth.se/labdev/ioboards), or the old IO-boxes in the labs using Comedi.
With this package, the user is able to setup a connection between the 
host computer and the IO-device, and send and 
receive control signals and measurements from the lab process.

The full documentation of the package is available [here](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/docs/build/index.md).

## Package Overview
The `LabConnections.jl` package is subdivided into two main modules; `Computer.jl` 
and `BeagleBone.jl`. `Computer.jl` defines the user interface on the host
computer side, while `BeagleBone.jl` defines low-level types and functions meant
to be used locally on the BBB.

### BeagleBone.jl
<img src="docs/images/beaglebonetypes.png" height="300" width="500">

This module defines types representing different pins and LEDs on the BBB, and
functions to change their status and behaviour. There are currently 4 different types defined
(each has the abstract super type `IO_Object`):
* `GPIO` : Represents the BBB's General Purpose Input Output (GPIO) pins. 
Each instance will correspond to a physical GPIO pin on the board, and can be 
set as an input or output pin, and to output high (1) or low (0).
* `PWM` : Represents the BBB's Pulse Width Modulation (PWM) pins. 
Each instance will correspond to a physical PWM pin on the board, which can be
turned on/off, and whose period, duty cycle and polarity can be specified.
* `SysLED` : Represents the 4 system LEDs on the BBB, and can be turned on/off.
Used to perform simple tests and debugging on the BBB.
* `Debug` : Used for debugging and pre-compilation on the BBB. It does 
not represent any physical pin or LED on the board.

**Note:** In addition to GPIO and PWM, the BBB also has pins dedicated for [Serial Peripheral
Interface](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus) (SPI).
Work to feature this functionality in `BeagleBone.jl` is currently ongoing. More
information can be found [here](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/docs/build/man/introduction.md#spi-development)


### Computer.jl
<img src="docs/images/computertypes.png" height="300" width="800">

This module contains the user interface on the host computer side, and defines 
types for devices/connections to the lab process, and filestreams between the 
host computer and different IO-devices (BBB or Comedi). There are currently 3 
different device/connection types (each has the abstract super type `AbstractDevice`):
* `AnalogInput10V` : Represents ±10V connections from the lab process to the IO-device. Each instance will correspond to a physical ±10V measurement signal from the lab process, whose value can be read.
* `AnalogOutput10V` : Represents ±10V connections from the IO-device to the lab process. Each instance will correspond to a physical ±10V input signal to the lab process, whose value can be set.  
* `SysLED` : Represents the System LEDs on the BBB. Used for simple testing and debugging from the host computer side.

There are 2 different filestream types (each has the abstract super type `LabStream`):
* `BeagleBoneStream` : Represents the data stream between the host computer and the BBB.
* `ComediStream` : Represent the data stream between the host computer and the old IO-boxes using Comedi. 

## Getting Started
### Installation
Instructions on installing the required software and setting up a connection between 
the host computer and the BBB are found [here](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/docs/build/man/installation.md#installation-instructions).

### A Simple Example
We will here go through a simple example of using the host computer interface to communicate with the BBB and control the onboard system LEDs.

First make sure that you have followed the installation guide, and that the BBB is running a server and is connected to the host computer.
Then, start the Julia REPL and input

    using LabConnections.Computer
to load the host computer interface. Then define a file stream `stream` and connect to the server running on the BBB by inputting

    stream = BeagleBoneStream(ip"192.168.7.2")
Now, we continue by defining the LED we want to control 

    led = SysLED(1)

The object `led` will now correspond to the first system LED on the BBB.
To tell the BBB that we want to control the LED, we make a call to `init_devices!`

    init_devices!(stream, led)
Now we can start controlling the LED on the BBB. Let's begin by turning it on

    put!(led, true)
    send(stream)
The function `put!` puts a new command (`true`) to a device (`led`) to the file stream buffer.
Then, the function `send` empties the buffer, and sends the commands to the BBB.
You should now see the first system LED on the BBB being lit.

### More Examples
There are several examples found [here](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/docs/build/examples/examples.md#examples)
which let's you test out the functionality of `LabConnections.jl`.


