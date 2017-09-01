var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "LabConnections",
    "title": "LabConnections",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#LabConnections-1",
    "page": "LabConnections",
    "title": "LabConnections",
    "category": "section",
    "text": "This is the documentation for the LabCommunication project, detailing installation instructions, examples and tests which may be run, as well as documenting the protocols and structure of the IO communication.Depth = 3"
},

{
    "location": "installation.html#",
    "page": "Installation Instructions",
    "title": "Installation Instructions",
    "category": "page",
    "text": ""
},

{
    "location": "installation.html#Installation-Instructions-1",
    "page": "Installation Instructions",
    "title": "Installation Instructions",
    "category": "section",
    "text": ""
},

{
    "location": "installation.html#On-the-HOST-1",
    "page": "Installation Instructions",
    "title": "On the HOST",
    "category": "section",
    "text": "To get started, first install julia v0.6.X on the PC running a Linux distribution by following the instructions specified here. So far, the system has only been testen on Ubuntu 14.* and 16.*.Once julia is installed julia, run`Pkg.clone(https://gitlab.control.lth.se/labdev/LabConnections.jl)'\n`Pkg.add(\"YAML\")'in the julia prompt to install all dependencies on the HOST."
},

{
    "location": "installation.html#On-the-BeagleBone-1",
    "page": "Installation Instructions",
    "title": "On the BeagleBone",
    "category": "section",
    "text": "On the BeagleBone, first install Debian for 32 bit ARM processors using a micro-SD by following this guide. You may also include a julia v0.6 tarball, alternatively transferring it using after an installation.If chosing the latter, connect the BB and download the julia tarball for ARM (ARMv7 32-bit hard float) from here and scp it to /home/debian/ on the BB. Run`cd ~/Downloads'\n`scp -r julia-0.6.0-linux-arm.tar.gz debian@192.168.7.2:/home/debian'next, log on to the BB via SSH by running`ssh debian@192.168.7.2'an unpack the tarball. Julia should now be operational by running`/home/debian/julia-<distro specific tag>/bin/julia'Next, open a new terminal on the HOST and cd to the /util directory of the LabConnection package by running in the julia package folder`cd && cd .julia/v0.6/LabConnection/util'This directory contains some nice utility files to operate the BB from the host. To flash it with the current revision of the software, including all dependencies, simply execut the shells cript `flash.sh'.(Image: block diagram)"
},

{
    "location": "installation.html#Setting-up-automatic-communication-between-the-BB-and-the-HOST-via-TCP-1",
    "page": "Installation Instructions",
    "title": "Setting up automatic communication between the BB and the HOST via TCP",
    "category": "section",
    "text": "To setup automatic start of Julia server on the BB, make sure to have completed all prior installation instructions. SSH to the BeagleBone and copy the julilaserver.service to the systemd/system`ssh debian@192.168.7.2'\n`sudo cp -r /home/debian/juliapackets/LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service` (on the BeagleBone)Then execute the commandssudo systemctl enable juliaserver (on the BeagleBone) sudo systemctl start juliaserver (on the BeagleBone)After a while, the BeagleBone should start blinking on SysLED 2: on-off-on-sleep-repeat. The server should now start automatically on restart of the BeagleBone, and you should be able to run the examples in in /Examples on the host computer."
},

{
    "location": "systemConfiguration.html#",
    "page": "System Configuration",
    "title": "System Configuration",
    "category": "page",
    "text": ""
},

{
    "location": "systemConfiguration.html#System-Configuration-1",
    "page": "System Configuration",
    "title": "System Configuration",
    "category": "section",
    "text": "The system configuration is designed easy human readable acceess to IO functionality and for speed in the real-time execution. Many pins may be used for different purposes, as can be seen in the diagram below, and the cofiguring of these pins is done on a low level. All pins are referred to by a generic string \"PX.YZ\". For example, the pin \"P9.28\" may be used in the PWM or the ADC (SPI), but not both simultaneously.(Image: block diagram)"
},

{
    "location": "systemConfiguration.html#Configuration-interfaces-1",
    "page": "System Configuration",
    "title": "Configuration interfaces",
    "category": "section",
    "text": "The interface to the BB pins is set in the srcBeagleBone/config/* directory. Many pins of the BB may have multiple settings, documented in the `pins.yml' interface. Any of the pins listed in this file may be incorporated in configuring a specific process. This is done my creating a new `*.yml' file in the config/ directory, with a set of pins and identifiers."
},

{
    "location": "systemConfiguration.html#Configuration-files-1",
    "page": "System Configuration",
    "title": "Configuration files",
    "category": "section",
    "text": "The configuration file is specified as a dictionary of lists assigned to the case-senstive keys \"gpio\", \"led\", \"pwm\", \"adc\", \"qed\". Each entry has an assigned list detailing a unique integer, a tuple of pins and a description. When loading such a configuration file, for instance using`components = YAML.load(open(\"example_configuration.yml\"))'all and specific components of a certain type will be accessed as`components[\"adc\"]'The unique integer is included for quick referencing of pins in the IO communication on the BB side, the description is used on the HOST side and the tuple of pins is in a human readable string format relating to the BB layout."
},

{
    "location": "systemConfiguration.html#Creating-configurations-1",
    "page": "System Configuration",
    "title": "Creating configurations",
    "category": "section",
    "text": "For instance, if a system is to be run with (1) two PWM signals, (2) ADC functionality over the SPI, (3) one quadrature encoder, (4) 4 input GPIOs and (5) 2 output GPIOs. These may be chosen as shown in the file `example_configuration.yml'.This file was created by runnig the create_configuration.jl' script in/utils', which checks consistency against `pins.yml' interactively. This script can be operated by running`julia create_configuration.jl example_configuration.yml'"
},

]}
