# Installation instructions
In these instructions we explain how to set up a working environment on a host computer and a BeagleBone Black (BB).

## Host computer setup

### Installing Julia and LabConnections.jl

To get started, first install Julia v1.0.X on the host computer running a Linux distribution by following the instructions specified [here](https://github.com/JuliaLang/julia/blob/master/README.md). Once Julia is installed, open up a Julia REPL and add LabConnections.jl using the package manager by typing
```
] add https://gitlab.control.lth.se/labdev/LabConnections.jl#julia1
```
You now have the LabConnections.jl package available on the host computer. Note that for Julia v1.0.X it is the branch `julia1` of the package that should be used.

### Installing Serbus
To work with SPI on the BB you will need a forked `serbus` repository which wraps the`linux/spi/spidev`. Open up a terminal and type
```
cd ~/.julia/packages
git clone https://github.com/mgreiff/serbus
```
to get the latest revision of the `serbus` fork. You are now done with the setup required on the host computer side.

## BeagleBone setup

### Preparing a micro-SD card
First, we will prepare a micro-SD card with an image of Debian and a binary of Julia, which we then can flash onto the BB.

Start by downloading the Debian image [here](http://beagleboard.org/latest-images) (Debian 9.5 2018-10-07 4GB SD IoT) and write the image onto a micro-SD card ([this guide](http://derekmolloy.ie/write-a-new-image-to-the-beaglebone-black/) is helpful).
Proceed by downloading the Julia v1.0 binary for 32-bit ARMv7 found [here](https://julialang.org/downloads/). Put the .tar-file of the Julia binary on the micro-SD card containing the Debian image under `/home/debian`, and unzip it.
Make sure that the Julia folder has the correct name by typing
```
mv /home/debian/julia-<distro specific tag> /home/debian/julia
```
The file structure on the micro-SD now has the correct structure.

The final step is to make sure that the micro-SD will automatically flash the Debian image onto the BB when booting up. To do this, follow the instructions found [here](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Flashing_eMMC). Congratulations, you now have a prepared micro-SD card ready for flashing a BB.

### Flashing the BeagleBone
Insert a prepared micro-SD card in the slot on the BB, and press down the boot button S2 (the button closest to the micro-SD slot) and hold it down while you plug in the USB-cable to the BB. Keep the S2 button held down for a couple of seconds, until the onboard LEDs start to blink. After a short while the onboard LEDs should start to blink in a wave pattern, indicating that the BB is being flashed. After a while (can vary between 5-45 minutes) the BB will be turn off automatically, indicating that the flashing is complete. Remove the micro-SD before powering on the BB again (otherwise it will start to flash the BB again).

### Accessing the BeagleBone
Now your BB should be ready to use. Log on to the BeagleBone via SSH by opening a terminal and typing
```
ssh debian@192.168.7.2
```
The default password is `temppwd`. You are now logged in to the BB running Debian. If the micro-SD was prepared correctly, the Julia binary should be located at `/home/debian/julia/bin/julia`.
You can now start a Julia REPL on the BB by typing
```
/home/debian/julia/bin/julia
```
If the Julia REPL starts up correctly, then you have a functioning BB ready for use with the LabConnections.jl package.

### Getting LabConnections.jl and serbus on the BeagleBone

To update the BB with the latest revision of the code, open up a terminal on the host computer and begin by cloning the `serbus` and `LabConnections.jl` repositories to a common directory
```
git clone https://github.com/mgreiff/serbus
git clone --branch julia1 https://gitlab.control.lth.se/labdev/LabConnections.jl.git
```
Then proceed by navigating to `LabConnections.jl/util` and run the `flash_BB.sh` shell script
```
cd LabConnections/util
./flash_BB.sh
```
This scripts bundles the current code in LabConnections.jl and serbus on the host computer and transfers it to the BB and puts it in the directory `/home/debian/juliapackages`.

<a id='Setting-up-automatic-communication-1'></a>

### Setting up the uEnv file
Since the deployment of the v4.14 kernel, the slots file and bone_capemgr have been permanantly disabled. This means that there is no need for compiling the device tree overlays as we did for the v0.6 version of the software stack. Instead, we need to configure the /boot/uEnv.txt file to enable the PWM pins correctly. Simply open the `/boot/uEnv.txt` file, add the line

```
cape_enable=bone_capemgr.enable_partno=univ-all,BB-ADC,BB-PWM0,BB-PWM1,BB-PWM2
```
and uncomment the line
```
disable_uboot_overlay_video=1
```
Reboot the BeagleBone, and you should now have access to the PWM pins.

### Setting up a Julia server on the BeagleBone
To setup automatic start of Julia server on the BB, make sure to have completed all prior installation instructions, and that the latest revision of the LabConnections package is located on the BB. SSH into the BB, and copy the file `juliaserver.service` to the folder `systemd/system`
```
ssh debian@192.168.7.2
sudo cp -r /home/debian/juliapackages/LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service
```
Then, still SSH:d into the BB, execute the commands
```
sudo systemctl enable juliaserver
sudo systemctl start juliaserver
```
After a while, the BB should start blinking onboard LED 2 in the following pattern: on-off-on-sleep-repeat. This indicates that the server on the BB is now running, and server should now start automatically every time you restart the BB. With this setup ready, you should be able to run the examples in the `/Examples` folder from the host computer.

Note that no errors will be seen on the BB when the automatic startup is used. For debugging purposes it can therefore also be useful to start the service manually on the BB. This way, any warnings or errors will be printed when starting up the Julia server. To start up the Julia server manually on the BB, SHH into the BB and start Julia as root
```
ssh debian@192.168.7.2
sudo /home/debian/julia/bin/julia
```
and then run the startup script
```
include("/home/debian/juliapackages/LabConnections/src/BeagleBone/startup/startup.jl")
```
