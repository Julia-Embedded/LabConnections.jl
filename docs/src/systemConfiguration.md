# System Configuration
The system configuration is designed easy human readable acceess to IO functionality and for speed in the real-time execution. Many pins may be used for different purposes, as can be seen in the diagram below, and the cofiguring of these pins is done on a low level. All pins are referred to by a generic string "PX.YZ". For example, the pin "P9.28" may be used in the PWM or the ADC (SPI), but not both simultaneously.

![block diagram](beaglebone_black_pinmap.png)

## Configuration interfaces
The interface to the BB pins is set in the `srcBeagleBone/config/*` directory. Many pins of the BB may have multiple settings, documented in the [`pins.yml'](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/src/BeagleBone/config/pins.yml) interface. Any of the pins listed in this file may be incorporated in configuring a specific process. This is done my creating a new `*.yml' file in the config/ directory, with a set of pins and identifiers.

## Configuration files
The configuration file is specified as a dictionary of lists assigned to the case-senstive keys "gpio", "led", "pwm", "adc", "qed". Each entry has an assigned list detailing a unique integer, a tuple of pins and a description. When loading such a configuration file, for instance using

    `components = YAML.load(open("example_configuration.yml"))'

all and specific components of a certain type will be accessed as

    `components["adc"]'

The unique integer is included for quick referencing of pins in the IO communication on the BB side, the description is used on the HOST side and the tuple of pins is in a human readable string format relating to the BB layout.

## Creating configurations
For instance, if a system is to be run with (1) two PWM signals, (2) ADC functionality over the SPI, (3) one quadrature encoder, (4) 4 input GPIOs and (5) 2 output GPIOs. These may be chosen as shown in the file [`example_configuration.yml'](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/src/BeagleBone/config/pins.yml).

This file was created by runnig the `create_configuration.jl' script in `/utils', which checks consistency against [`pins.yml'](https://gitlab.control.lth.se/labdev/LabConnections.jl/blob/master/src/BeagleBone/config/pins.yml) interactively. This script can be operated by running

    `julia create_configuration.jl example_configuration.yml'
