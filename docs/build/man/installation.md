
<a id='Installation-instructions-1'></a>

# Installation instructions


In these instructions we explain how to set up a working environment on a host computer and a BeagleBone Black (BBB).


<a id='Host-computer-setup-1'></a>

## Host computer setup


<a id='Installing-Julia-and-LabConnections.jl-1'></a>

### Installing Julia and LabConnections.jl


To get started, first install Julia v1.0.X on the host computer running a Linux distribution by following the instructions specified [here](https://github.com/JuliaLang/julia/blob/master/README.md). Once Julia is installed, open up a Julia REPL and add LabConnections.jl using the package manager by typing


```
] add https://gitlab.control.lth.se/labdev/LabConnections.jl#julia1
```


You now have the LabConnections.jl package available on the host computer. Note that for Julia v1.0.X it is the branch `julia1` of the package that should be used.


<a id='Installing-Serbus-1'></a>

### Installing Serbus


To work with the SPI devices you will need a forked `serbus` repository which wraps the`linux/spi/spidev`. Open up a terminal and type


```
cd ~/.julia/packages
git clone https://github.com/mgreiff/serbus
```


to get the latest revision of the `serbus` fork. You are now done with the setup required on the host computer side.


<a id='BeagleBone-setup-1'></a>

## BeagleBone setup


<a id='Preparing-a-micro-SD-card-1'></a>

### Preparing a micro-SD card


First, we will prepare a micro-SD card with an image of Debian and a binary of Julia, which we then can flash onto the BBB.


Start by downloading the Debian image [here](http://beagleboard.org/latest-images) (Debian 9.5 2018-10-07 4GB SD IoT) and write the image onto a micro-SD card ([this guide](http://derekmolloy.ie/write-a-new-image-to-the-beaglebone-black/) is helpful). Proceed by downloading the Julia v1.0 binary for 32-bit ARMv7 found [here](https://julialang.org/downloads/). Put the .tar-file of the Julia binary on the micro-SD card containing the Debian image under `/home/debian`, and unzip it. Make sure that the Julia folder has the correct name by typing


```
mv /home/debian/julia-<distro specific tag>/bin/julia /home/debian/julia/bin/julia
```


The file structure on the micro-SD now has the correct structure.


The final step is to make sure that the micro-SD will automatically flash the Debian image onto the BBB when booting up. To do this, follow the instructions found [here](https://elinux.org/Beagleboard:BeagleBoneBlack_Debian#Flashing_eMMC). Congratulations, you now have a prepared micro-SD card ready for flashing a BBB.


<a id='Flashing-the-BeagleBone-1'></a>

### Flashing the BeagleBone


Insert a prepared micro-SD card in the slot on the BBB, and press down the boot button S2 (the button closest to the micro-SD slot) and hold it down while you plug in the USB-cable to the BBB. Keep the S2 button held down for a couple of seconds, until the onboard LEDs start to blink. After a short while the onboard LEDs should start to blink in a wave pattern, indicating that the BBB is being flashed. After a while (can vary between 5-45 minutes) the BBB will be turn off automatically, indicating that the flashing is complete. Remove the micro-SD before powering on the BBB again (otherwise it will start to flash the BBB again).


<a id='Accessing-the-BeagleBone-1'></a>

### Accessing the BeagleBone


Now your BBB should be ready to use. Log on to the BeagleBone via SSH by opening a terminal and typing


```
ssh debian@192.168.7.2
```


The default password is `temppwd`. You are now logged in to the BBB running Debian. If the micro-SD was prepared correctly, the Julia binary should be located at `/home/debian/julia/bin/julia`. You can now start a Julia REPL on the BBB by typing


```
/home/debian/julia/bin/julia
```


If the Julia REPL starts up correctly, then you have a functioning BBB ready for use with the LabConnections.jl package.


<a id='Getting-LabConnections.jl-and-serbus-on-the-BeagleBone-1'></a>

### Getting LabConnections.jl and serbus on the BeagleBone


To update the BBB with the latest revision of the code, open up a terminal on the host computer and begin by cloning the `serbus` and `LabConnections.jl` repositories to a common directory


```
git clone https://github.com/mgreiff/serbus
git clone --branch julia1 https://gitlab.control.lth.se/labdev/LabConnections.jl.git
```


Then proceed by navigating to `LabConnections.jl/util` and run the `flash_BB.sh` shell script


```
cd LabConnections/util
./flash_BB.sh
```


This scripts bundles the current code in LabConnections.jl and serbus on the host computer and transfers it to the BBB and puts it in the directory `/home/debian/juliapackages`.


<a id='Setting-up-automatic-communication-1'></a>


<a id='Setting-up-a-Julia-server-on-the-BeagleBone-1'></a>

### Setting up a Julia server on the BeagleBone


To setup automatic start of Julia server on the BBB, make sure to have completed all prior installation instructions, and that the latest revision of the LabConnections package is located on the BBB. SSH into the BBB, and copy the file `juliaserver.service` to the folder `systemd/system`


```
ssh debian@192.168.7.2
sudo cp -r /home/debian/juliapackages/LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service
```


Then, still SSH:d into the BBB, execute the commands


```
sudo systemctl enable juliaserver
sudo systemctl start juliaserver
```


After a while, the BBB should start blinking onboard LED 2 in the following pattern: on-off-on-sleep-repeat. This indicates that the server on the BBB is now running, and server should now start automatically every time you restart the BBB. With this setup ready, you should be able to run the examples in the `/Examples` folder from the host computer.


Note that no errors will be seen on the BeagleBone when the automatic startup is used. For debugging purposes it can therefore also be useful to start the service manually on the BBB. This way, any warnings or errors will be printed when starting up the Julia server. To start up the Julia server manually on the BBB, SHH into the BBB and start Julia as root


```
ssh debian@192.168.7.2
sudo /home/debian/julia/bin/julia
```


and then run the startup script


```
include("/home/debian/juliapackages/LabConnections/src/BeagleBone/startup/startup.jl")
```

