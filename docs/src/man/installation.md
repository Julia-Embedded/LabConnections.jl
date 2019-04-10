<a id='Installation-Instructions-1'></a>

# Installation Instructions
In these instructions we explain how to set up a working environment on a host computer and
a BeagleBone Black. If you already have a prepared micro-SD card for flashing a BeagleBone, 
then you can safely skip the first section of these instructions.


<a id='On-the-BBB-1'></a>

## Preparing a micro-SD card
First, we will prepare a micro-SD card with an image of Debian and a binary of Julia, which we then can flash onto the BeagleBone. Start by downloading the Debian image [here](http://beagleboard.org/latest-images) (Debian 9.5 2018-10-07 4GB SD IoT) and write the image onto a micro-SD card ([this guide](http://derekmolloy.ie/write-a-new-image-to-the-beaglebone-black/) is helpful).
Proceed by downloading the Julia v1.0 binary for 32-bit ARMv7 found [here](https://julialang.org/downloads/). Put the .tar-file of the Julia binary on the micro-SD card containing the Debian image under `/home/debian`, and unzip it. 
Make sure that the Julia folder has the correct name by typing
```
`mv /home/debian/julia-<distro specific tag>/bin/julia /home/debian/julia/bin/julia'
```
The file structure on the micro-SD now has the correct structure. The final step is to make sure that the micro-SD will automatically flash the Debian image onto the BeagleBone when booting up. To do this, follow the instructions found [here](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Flashing_eMMC). Congratulations,
you now have a prepared micro-SD card ready for flashing BeagleBones.

## Flashing a BeagleBone from a prepared micro-SD card
Insert the micro-SD card in the slot on the BeagleBone, and press down the boot button S2 (the button closest to the micro-SD slot) and hold it down while you plug
in the USB-cable to the BeagleBone. Keep the S2 button held down for a couple of seconds, until the onboard LEDs start to blink. After a short while the onboard LEDs should
start to flash in a wave pattern, indicating that the BeagleBone is being flashed. After a while (can vary between 5-45 minutes) the BeagleBone will be turn off automatically,
indicating that the flashing is complete. Remove the micro-SD before powering on the BeagleBone again (otherwise it will start to flash the BeagleBone again).

## Trying out the BeagleBone
Now your BeagleBone is ready to use. Log on to the BeagleBone via SSH by opening a terminal and typing
```
`ssh debian@192.168.7.2'
```
The default password is `temppwd`. You are now logged in to the BeagleBone running Debian. The Julia binary should be located at `/home/debian/julia-/bin/julia`. 
You can now start a Julia REPL on the BeagleBone by typing
```
`/home/debian/julia-<distro specific tag>/bin/julia'
```
If this works correctly, then you have a functioning BeagleBone ready for use with the LabConnections.jl package.

<a id='On-the-HOST-1'></a>

## Setting up the host computer


To get started, first install Julia v1.0.X on the host computer running a Linux distribution by following the instructions specified [here](https://github.com/JuliaLang/julia/blob/master/README.md). Once Julia is installed, run
```
using Pkg
`Pkg.clone(https://gitlab.control.lth.se/labdev/LabConnections.jl)'
```
in the Julia REPL to install all dependencies on the host computer. The source code is then located in `./julia/v1.0/LabConnections'.


If you plan on working with the SPI devices to debug the ADC/DAC, then you will need a forked `serbus' repository which wraps the`linux/spi/spidev'. Simply


```
`cd && cd .julia/v0.6'
`git clone https://github.com/mgreiff/serbus'
```


to get the latest revision of the serbus fork.


To update the BB with the latest revision of the code,  


```
`cd && cd .julia/v0.6/LabConnection/util'
`./flash_BB.sh'
```


This scripts bundles the current code in LabCOnnections and serbus on the host computer and transfers it to the /home/debian/juliapackages directory on the BB.


<a id='Setting-up-automatic-communication-1'></a>

## Setting up automatic communication


To setup automatic start of Julia server on the BB, make sure to have completed all prior installation instructions, and that the lates revision of the LabConnections package is located on the BB. SSH to the BeagleBone and copy the julilaserver.service to the systemd/system


```
`ssh debian@192.168.7.2'
`sudo cp -r /home/debian/juliapackets/LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service` (on the BeagleBone)
```


Then execute the commands


`sudo systemctl enable juliaserver` (on the BeagleBone) `sudo systemctl start juliaserver` (on the BeagleBone)


After a while, the BeagleBone should start blinking on SysLED 2: on-off-on-sleep-repeat. The server should now start automatically on restart of the BeagleBone, and you should be able to run the examples in in /Examples on the host computer.


```@systemConfiguration

```


<a id='Debugging-1'></a>

## Debugging


No errors will be seen on the BeagleBone when the automatic startup is used. For debugging purposes it might be useful to start the service manually on the beagle bone. Start julia as root:


```
sudo /home/debian/julia/bin/julia
```


and run the startup script:


```
include("/home/debian/juliapackages/LabConnections/src/BeagleBone/startup/startup.jl")
```

