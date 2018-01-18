[![pipeline status](https://gitlab.control.lth.se/labdev/LabConnections.jl/badges/master/pipeline.svg)](https://gitlab.control.lth.se/labdev/LabConnections.jl/commits/master)
[![coverage report](https://gitlab.control.lth.se/labdev/LabConnections.jl/badges/master/coverage.svg)](https://gitlab.control.lth.se/labdev/LabConnections.jl/commits/master)

# Welcome to LabConnections.jl - the IO-software part of the LabDev project

The goal of this project is to develop a software package in [Julia](https://julialang.org/) 
for interfacing with lab processes using either the [BeagleBone Black Rev C](http://beagleboard.org/) (BBB)
with custom [IO-board cape](https://gitlab.control.lth.se/labdev/ioboards), or the old IO-boxes in the labs using Comedi.
With this package, the user is able to setup a connection between the 
host computer and the IO-device, and send and 
receive control signals and measurements from the lab process.

The full documentation of the package is available [here](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/docs/build/index.md).

## Package Overview
The `LabConnections.jl` package is subdivided into two main modules; `BeagleBone.jl`
and `Computer.jl`. `BeagleBone.jl` defines low-level types and functions meant
to be used locally on the BBB, and `Computer.jl` defines the user interface on the host
computer side. Below is an overview of the modules.

### BeagleBone.jl
This module defines types representing different pins and LEDs on the BBB, and
functions to change their status and behaviour. There are 4 different types defined
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

### Computer.jl
This module contains the user interface on the host computer side, and defines 
types for devices/connections to the lab process, and filestreams between the 
host computer and different IO-devices (BBB or Comedi). There are currently 3 
different device/connection types (each has the abstract super type `AbstractDevice`):
* `AnalogInput10V` : Represents ±10V connections from the lab process to the IO-device. Each instance will correspond to a physical ±10V measurement signal from the lab process, whose value can be read.
* `AnalogOutput10V` : Represents ±10V connections from the IO-device to the lab process. Each instance will correspond to a physical ±10V input signal to the lab process, whose value can be set.  
* `SysLED` : Represents the System LEDs on the BBB. Used for simple testing and debugging from the host computer side.

There are 2 different filestream types (each has the abstract super type `LabStream`):
* `BeagleBoneStream` : 
* `ComediStream` : 


## Getting Started

### Installation

### Running a Simple Example

## Repository Structure
The package is subdivided into two main modules; 

# OBS! SPI development
The SPI development is done in C and in a forked repository, currently
separated from the julia project. If you wish to work on the SPI implementation,
simply clone the repository "serbus", a small C stack available at
`github.com/mgreiff/serbus` into your julia package directory (for example
`~/.julia/v0.6`). Then, in the LabConnections package on the host computer, run
`flash_BB.sh` in the `/utils` directory transferring both LabConnections and
serbus to the BB.

On the BB, run

    cp /home/debian/juliapackages/serbus/bb_spi.sh /home/debian

and then execute

    ./bb_spi.sh

in the `/home/debian` directory to run the SPI example with the ADC from SPI0.
