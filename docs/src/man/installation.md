# Installation Instructions

## On the BBB
On the BeagleBone, first flash it with a Debian image for 32 bit ARM processors
(BeagleBoard.org Debian Image 2017-03-19) using a micro-SD by following [this guide](http://derekmolloy.ie/write-a-new-image-to-the-beaglebone-black/).
You may also include a Julia v0.6 tarball, alternatively transferring it
using after an installation.

If using the provided SD card, flash the BB by holding down S2 for about 5
seconds while connecting the BB to 5V power. Keep the button pressed until the
four system LEDs (D2/D3/D4/D5) start blinking in a periodical sequence. Leave
the BB alone for 15-20 minutes while flashing, until all four lights are turned
off (or on). Power off the BB, remove the SD card, and power it on again.

Log on to the BB via SSH by

    `ssh debian@192.168.7.2'

an unpack the tarball. Julia should now be operational by running

    `/home/debian/julia-<distro specific tag>/bin/julia'

and before leaving the BB, remove the distibution specific tag by renaming

    `mv /home/debian/julia-<distro specific tag>/bin/julia /home/debian/julia/bin/julia'

## On the HOST
To get started, first install Julia v0.6.X on the PC running a Linux
distribution by following the instructions specified
[here](https://github.com/JuliaLang/julia/blob/master/README.md). So far, the
system has only been tested on Ubuntu 14.04 and 16.04.

Once Julia is installed, run

    `Pkg.clone(https://gitlab.control.lth.se/labdev/LabConnections.jl)'

in the Julia prompt to install all dependencies on the HOST, the source code
is then located in `./julia/v0.6/LabCOnnections'.

If you plan on working with the SPI devices to debug the ADC/DAC, then you will
need a forked `serbus' repository which wraps the `linux/spi/spidev'. Simply

    `cd && cd .julia/v0.6'
    `git clone https://github.com/mgreiff/serbus'

to get the latest revision of the serbus fork.

To update the BB with the latest revision of the code,  

    `cd && cd .julia/v0.6/LabConnection/util'
    `./flash_BB.sh'

This scripts bundles the current code in LabCOnnections and serbus on the host
computer and transfers it to the /home/debian/juliapackages directory on the BB.

## Setting up automatic communication
To setup automatic start of Julia server on the BB, make sure to have completed
all prior installation instructions, and that the lates revision of the
LabConnections package is located on the BB. SSH to the BeagleBone and copy the
julilaserver.service to the systemd/system

    `ssh debian@192.168.7.2'
    `sudo cp -r /home/debian/juliapackets/LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service` (on the BeagleBone)

Then execute the commands

`sudo systemctl enable juliaserver` (on the BeagleBone)
`sudo systemctl start juliaserver` (on the BeagleBone)

After a while, the BeagleBone should start blinking on SysLED 2: on-off-on-sleep-repeat. The server should now start automatically on restart of the BeagleBone, and you should be able to run the examples in in /Examples on the host computer.

```@systemConfiguration
```


## Debugging

No errors will be seen on the BeagleBone when the automatic startup is used. For debugging purposes it might be useful to start the service manually on the beagle bone.
Start julia as root:
```
sudo /home/debian/julia/bin/julia
```
and run the startup script:
```
include("/home/debian/juliapackages/LabConnections/src/BeagleBone/startup/startup.jl")
```
