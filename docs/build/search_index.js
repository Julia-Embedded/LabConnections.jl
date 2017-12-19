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
    "location": "installation.html#On-the-BBB-1",
    "page": "Installation Instructions",
    "title": "On the BBB",
    "category": "section",
    "text": "On the BeagleBone, first flash it with a Debian image for 32 bit ARM processors (BeagleBoard.org Debian Image 2017-03-19) using a micro-SD by following this guide. You may also include a Julia v0.6 tarball, alternatively transferring it using after an installation.If using the provided SD card, flash the BB by holding down S2 for about 5 seconds while connecting the BB to 5V power. Keep the button pressed until the four system LEDs (D2/D3/D4/D5) start blinking in a periodical sequence. Leave the BB alone for 15-20 minutes while flashing, until all four lights are turned off (or on). Power off the BB, remove the SD card, and power it on again.Log on to the BB via SSH by`ssh debian@192.168.7.2'an unpack the tarball. Julia should now be operational by running`/home/debian/julia-<distro specific tag>/bin/julia'and before leaving the BB, remove the distibution specific tag by renaming`mv /home/debian/julia-<distro specific tag>/bin/julia /home/debian/julia/bin/julia'"
},

{
    "location": "installation.html#On-the-HOST-1",
    "page": "Installation Instructions",
    "title": "On the HOST",
    "category": "section",
    "text": "To get started, first install Julia v0.6.X on the PC running a Linux distribution by following the instructions specified here. So far, the system has only been tested on Ubuntu 14.04 and 16.04.Once Julia is installed, run`Pkg.clone(https://gitlab.control.lth.se/labdev/LabConnections.jl)'in the Julia prompt to install all dependencies on the HOST, the source code is then located in `./julia/v0.6/LabCOnnections'.If you plan on working with the SPI devices to debug the ADC/DAC, then you will need a forked serbus' repository which wraps thelinux/spi/spidev'. Simply`cd && cd .julia/v0.6'\n`git clone https://github.com/mgreiff/serbus'to get the latest revision of the serbus fork.To update the BB with the latest revision of the code,  `cd && cd .julia/v0.6/LabConnection/util'\n`./flash_BB.sh'This scripts bundles the current code in LabCOnnections and serbus on the host computer and transfers it to the /home/debian/juliapackages directory on the BB."
},

{
    "location": "installation.html#Setting-up-automatic-communication-1",
    "page": "Installation Instructions",
    "title": "Setting up automatic communication",
    "category": "section",
    "text": "To setup automatic start of Julia server on the BB, make sure to have completed all prior installation instructions, and that the lates revision of the LabConnections package is located on the BB. SSH to the BeagleBone and copy the julilaserver.service to the systemd/system`ssh debian@192.168.7.2'\n`sudo cp -r /home/debian/juliapackets/LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service` (on the BeagleBone)Then execute the commandssudo systemctl enable juliaserver (on the BeagleBone) sudo systemctl start juliaserver (on the BeagleBone)After a while, the BeagleBone should start blinking on SysLED 2: on-off-on-sleep-repeat. The server should now start automatically on restart of the BeagleBone, and you should be able to run the examples in in /Examples on the host computer."
},

{
    "location": "systemConfiguration.html#",
    "page": "System Configuration (deprecated)",
    "title": "System Configuration (deprecated)",
    "category": "page",
    "text": ""
},

{
    "location": "systemConfiguration.html#System-Configuration-(deprecated)-1",
    "page": "System Configuration (deprecated)",
    "title": "System Configuration (deprecated)",
    "category": "section",
    "text": "The system configuration is designed easy human readable acceess to IO functionality and for speed in the real-time execution. Many pins may be used for different purposes, as can be seen in the diagram below, and the cofiguring of these pins is done on a low level. All pins are referred to by a generic string \"PX.YZ\". For example, the pin \"P9.28\" may be used in the PWM or the ADC (SPI), but not both simultaneously.(Image: block diagram)"
},

{
    "location": "systemConfiguration.html#Configuration-interfaces-(deprecated)-1",
    "page": "System Configuration (deprecated)",
    "title": "Configuration interfaces (deprecated)",
    "category": "section",
    "text": "The interface to the BB pins is set in the srcBeagleBone/config/* directory. Many pins of the BB may have multiple settings, documented in the `pins.yml' interface. Any of the pins listed in this file may be incorporated in configuring a specific process. This is done my creating a new `*.yml' file in the config/ directory, with a set of pins and identifiers."
},

{
    "location": "systemConfiguration.html#Configuration-files-1",
    "page": "System Configuration (deprecated)",
    "title": "Configuration files",
    "category": "section",
    "text": "The configuration file is specified as a dictionary of lists assigned to the case-senstive keys \"gpio\", \"led\", \"pwm\", \"adc\", \"qed\". Each entry has an assigned list detailing a unique integer, a tuple of pins and a description. When loading such a configuration file, for instance using`components = YAML.load(open(\"example_configuration.yml\"))'all and specific components of a certain type will be accessed as`components[\"adc\"]'The unique integer is included for quick referencing of pins in the IO communication on the BB side, the description is used on the HOST side and the tuple of pins is in a human readable string format relating to the BB layout."
},

{
    "location": "systemConfiguration.html#Creating-configurations-1",
    "page": "System Configuration (deprecated)",
    "title": "Creating configurations",
    "category": "section",
    "text": "For instance, if a system is to be run with (1) two PWM signals, (2) ADC functionality over the SPI, (3) one quadrature encoder, (4) 4 input GPIOs and (5) 2 output GPIOs. These may be chosen as shown in the file `example_configuration.yml'.This file was created by runnig the create_configuration.jl' script in/utils', which checks consistency against `pins.yml' interactively. This script can be operated by running`julia create_configuration.jl example_configuration.yml'"
},

{
    "location": "testing.html#",
    "page": "Tests",
    "title": "Tests",
    "category": "page",
    "text": ""
},

{
    "location": "testing.html#Tests-1",
    "page": "Tests",
    "title": "Tests",
    "category": "section",
    "text": "The BeagleBone tests can be run on any computer, regrdless of their file-syste. By setting the flag RUNNING_TESTS to true, a dummy file-system is exported in which the tests are run operate. This has the advantage of enabling testing of the code run on the BB free from the BB itself, without building the Debian FS, thereby enabling the automatic testing through Travis.To run the tests, simply enter the /test/ directory and runjulia run_tests.jlIf the tests are to be run on the BB with hardware in the loop, runjulia run_tests.jlon the BB, to run examples separately, see... examples ..."
},

{
    "location": "examples.html#",
    "page": "Examples on the BB",
    "title": "Examples on the BB",
    "category": "page",
    "text": ""
},

{
    "location": "examples.html#Examples-on-the-BB-1",
    "page": "Examples on the BB",
    "title": "Examples on the BB",
    "category": "section",
    "text": "The following examples may be run from the BB, and may require the user to export the the LabConnections module to the LOAD_PATH manually, executing the following line in the Julia promptpush!(LOAD_PATH, \"/home/debian/juliapackages\")When running the examples with hardware in the loop, take caution not to short the BB ground with any output pin, as this will damage the board. For instance, if connecting a diode to the output pins, always use a resistor of >1000 Ohm in parallel. See the configuration page for information on which functionality specific pins support.Pages = [\"examples.md\"]\nDepth = 3"
},

{
    "location": "examples.html#Example-with-LEDs-(BB)-1",
    "page": "Examples on the BB",
    "title": "Example with LEDs (BB)",
    "category": "section",
    "text": "To test the system LED functionality of the Julia code from the BBB, open a Julia prompt and run the SYS_LED_test.jl fileinclude(\"/home/debian/juliapackages/LabConnections/test/BeagleBone/SYS_LED_test.jl\")This example runs a test with hardware in the loop, exporting and unexporting the SYS_LED devices and blinking led D2-D5 in a sequence over 1 second, alternating with D2/D4 and D3/D5 on/off."
},

{
    "location": "examples.html#Example-with-GPIOs-(BB)-1",
    "page": "Examples on the BB",
    "title": "Example with GPIOs (BB)",
    "category": "section",
    "text": "To test the GPIO functionality of the Julia code from the BBB, open a Julia prompt and run the GPIO_test.jl fileinclude(\"/home/debian/juliapackages/LabConnections/test/BeagleBone/GPIO_test.jl\")This again runs the tests with the BBB in the loop, testing exception handling exporting of the file system and also runs all the GPIOs on the board high/low at a 0.1 period time over 1 second to demonstrate the IO communication visually."
},

{
    "location": "examples.html#Example-with-PWM-(BB)-1",
    "page": "Examples on the BB",
    "title": "Example with PWM (BB)",
    "category": "section",
    "text": "To test the PWM functionality of the Julia code from the BBB, open a Julia prompt and run the PWM_test.jl fileinclude(\"/home/debian/juliapackages/LabConnections/test/BeagleBone/PWM_test.jl\")This runs the PWM tests with the BBB in the loop, testing exception handling exporting of the file system. In addition, it runs all the PWM pins on the board with a duty cycle of 0.5 over a period time over 1 second to demonstrate the IO communication visually."
},

{
    "location": "examples.html#Example-with-SPI-(BB)-1",
    "page": "Examples on the BB",
    "title": "Example with SPI (BB)",
    "category": "section",
    "text": "All development on the SPI is currently done in C in a for of the serbus package. Consequently, this example is currently run completely separate from the LabConnections.Make sure that the serbus package exists in the /juliapackages/ directory, where it is automatically placed when transferring code to the BB using the ./flash_BB shell script. Then simply runcp /home/debian/juliapackages/serbus/bb_spi.sh /home/debianand execute./bb_spi.shin the /home/debian/ directory. The program thenCompiles a device tree overlay (should SPI1 be used)\nCreates the binaries for the SPI driver and example\nRuns the MCP3903 example script located in spi_MCP3903.cThe purpose of the program is to configure the ADC to operate in the continuous mode and then read the registers, outputting the measurements in the terminal."
},

{
    "location": "examples.html#Example-with-LEDs-(HOST)-1",
    "page": "Examples on the BB",
    "title": "Example with LEDs (HOST)",
    "category": "section",
    "text": "To operate the LEDs from the host computer, simply connect the BBB to the HOST via USB and run the \"testLED.jl\" on the HOSTcd && cd .julia/v0.6/LabConnections/Examples/ && julia testLED.jl"
},

]}
