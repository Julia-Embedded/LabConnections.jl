# Instructions on compiling and loading a device tree overlay
The BeagleBone Black (BBB) uses device tree overlays (DTOs) to specify the operation and 
default settings of the pins. You can read more about using DTOs 
for the BBB [here](https://learn.adafruit.com/introduction-to-the-beaglebone-black-device-tree/overview).
Here we give instructions on how to compile and load the overlay `cape-universallc`
found in this folder. All commands in the instructions are performed on the BBB.

First, make sure to have a copy of the file `cape-universallc-00A0.dts` in the folder `/lib/firmware`
on the BBB:
```shell
cp cape-universallc-00A0.dts /lib/firmware
```
Then we use the device tree compiler (dtc) to compile the human readable 
`.dts`-file into a `.dtbo`-file usable by the Linux kernel:
```shell
cd /lib/firmware
dtc -0 dtb -o cape-universallc-00A0.dtbo -b 0 -@ cape-universallc-00A0.dts
```
Now we have a new file `cape-universallc-00A0.dtbo` in `/lib/firmware/`. To load
the new DTO, we send it to the slots-file of the BBB:
```shell
echo cape-universallc > /sys/devices/bone_capemgr.*/slots
```
Note that the extension `-00A0.dtbo` is omitted in the command above. To check 
that the overlay has been loaded properly we can check the slots file:
```shell
cat /sys/devices/bone_capemgr.*/slots
```
which should give the following printout:
```shell
 0: 54:PF--- 
 1: 55:PF--- 
 2: 56:PF--- 
 3: 57:PF--- 
 4: ff:P-O-L Bone-LT-eMMC-2G,00A0,Texas Instrument,BB-BONE-EMMC-2G
 5: ff:P-O-L Bone-Black-HDMI,00A0,Texas Instrument,BB-BONELT-HDMI
 8: ff:P-O-L Override Board Name,00A0,Override Manuf,cape-universallc
```
Here the overlays in slots 4 and 5 are related to the eMMC and HDMI, while the 
new overlay `cape-universallc` is loaded to slot 8. Now the behaviour of the BBBs 
pins is properly defined, and you can start using the framework of `LabConnections.BeagleBone`.

### Note about `cape-universallc`
The DTO `cape-universallc` is essentially identical to the standard DTO
`cape-universaln` found [here](https://github.com/cdsteinkuehler/beaglebone-universal-io) 
which exports all pins except for those used by the HDMI and eMMC. However, there 
is a bug in the default version of `cape-universaln` found on the BBB (described [here](https://github.com/cdsteinkuehler/beaglebone-universal-io/issues/21)), 
which prevents it from loading properly. This bug has been taken care of in `cape-universallc`.