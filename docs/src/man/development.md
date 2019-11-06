# Package Development

## Host computer development environment
If you want to develop the code in LabConnections.jl, then this is how you setup a development environment. First, open up a Julia REPL and type
```
] dev https://gitlab.control.lth.se/labdev/LabConnections.jl
```
Open a new terminal and navigate to `.julia/dev/LabConnections`, where the package source code is now located. Then type
```
git checkout julia1
git pull
```
to ensure that you are working on the correct development branch for Julia v1.0.X. You can now edit the code in `.julia/dev/LabConnections`
and run it using a Julia REPL. When you are satisfied with your changes, simply commit and push the changes in the `.julia/dev/LabConnections` directory to the GitLab server.

## Development with the BeagleBone

### Transferring development code from host to the BeagleBone
Because of the limited performance of the BeagleBone (BB), it is often preferable to do most code development on the host computer. However, you will also do testing of the code locally on the BB, and will thus need to transfer the latest code from the host computer to the BB. To do this, there is a handy utility shell script found in `/util` that handles this. Open a terminal on the host computer and type
```
cd ~/.julia/dev/LabConnections/util
./copyfoldertobb.sh
```
This will transfer the current development version of `LabConnections.jl` found in the `/dev` directory to the BB.

### Development with hardware in the loop
When testing `LabConnections.jl` with hardware in the loop, the external hardware will be connected to the pin headers on the BB. For reference, the pin map of the BeagleBone (BB) is shown below.

<p align="center">
<img src="../fig/beaglebone_black_pinmap.png" height="500" width="900">
</p>

When running examples and tests with hardware in the loop, take caution not to short the BB ground with any output pin, as this will damage the board. For instance, if connecting a diode to the output pins, always use a resistor of >1 kOhm in parallel.

## Notes on updates with the >=v.4.14 kernel
At the time of writing, the image used to flash the beaglebone is
a v4.14 kernel, more specifically Linux beaglebone 4.14.71-ti-r80.

Since the deployment of the v4.14 kernel, the slots file and bone_capemgr have been permanantly disabled. This means that there is no need for compiling the device tree overlays as we did for the v0.6 version of the software stack. Instead, we need to configure the /boot/uEnv.txt file to enable the PWM pins correctly. Simply open the `/boot/uEnv.txt` file, add the line

```
cape_enable=bone_capemgr.enable_partno=univ-all,BB-ADC,BB-PWM0,BB-PWM1,BB-PWM2
```
and uncomment the line
```
disable_uboot_overlay_video=1
```
Reboot the BeagleBone, and you should now have access to the PWM pins.

### Changes to the device maps
The filesystem has also changed with 4.14. we now have a pwm device in
`/sys/class/pwm` where we can export and then write to the PWM pins of
of the BBB. However, in order to do this, we first need to idetify which
pwm chip that corresponds to which pin.

The address of each PWM interface is
```
> ls -lh /sys/class/pwm

lrwxrwxrwx 1 root pwm 0 Oct  7 16:40 pwmchip0 -> ../../devices/platform/ocp/48300000.epwmss/48300100.ecap/pwm/pwmchip0
lrwxrwxrwx 1 root pwm 0 Oct  7 16:40 pwmchip1 -> ../../devices/platform/ocp/48300000.epwmss/48300200.pwm/pwm/pwmchip1
lrwxrwxrwx 1 root pwm 0 Oct  7 16:40 pwmchip3 -> ../../devices/platform/ocp/48302000.epwmss/48302100.ecap/pwm/pwmchip3
lrwxrwxrwx 1 root pwm 0 Oct  7 16:40 pwmchip4 -> ../../devices/platform/ocp/48302000.epwmss/48302200.pwm/pwm/pwmchip4
lrwxrwxrwx 1 root pwm 0 Oct  7 16:40 pwmchip6 -> ../../devices/platform/ocp/48304000.epwmss/48304100.ecap/pwm/pwmchip6
lrwxrwxrwx 1 root pwm 0 Oct  7 16:40 pwmchip7 -> ../../devices/platform/ocp/48304000.epwmss/48304200.pwm/pwm/pwmchip7
```
Page 184 of the TI AM335x and AMIC110 Sitara Processors Technical Reference Manual gives the memory map for the PWM chips
```
    PWM Subsystem 0: 0x48300000
        eCAP0: 0x48300100
        ePWM0: 0x48300200
    PWM Subsystem 1: 0x48302000
        eCAP1: 0x48302100
        ePWM1: 0x48302200
    PWM Subsystem 2: 0x48304000
        eCAP2: 0x48304100
        ePWM2: 0x48304200
```
From this we can conclude that
```
ECAP0   (eCAP0) is pwmchip0
EHRPWM0 (ePWM0) is pwmchip1
eCAP1   (eCAP1) is pwmchip3
EHRPWM1 (ePWM1) is pwmchip4
eCAP2   (eCAP2) is pwmchip6
EHRPWM2 (ePWM2) is pwmchip7
```
Based on the headers on the BeagleBone expansion cape
```
EHRPWM0A = P9_22
EHRPWM0B = P9_21
EHRPWM1A = P9_14
EHRPWM1B = P9_16
EHRPWM2A = P8_19
EHRPWM2B = P8_13
ECAP0    = P9_42
```

which means that we get a mapping
```
const pwm_pins = Dict(
    "P9.22" => ("PWM0A", "pwmchip1", "0"),
    "P9.21" => ("PWM0B", "pwmchip1", "1"),
    "P9.14" => ("PWM1A", "pwmchip4", "0"),
    "P9.16" => ("PWM1B", "pwmchip4", "1"),
    "P8.19" => ("PWM2A", "pwmchip7", "0"),
    "P8.13" => ("PWM2B", "pwmchip7", "1"),
)
```
note that before the v4.14 kernel, this mapping was
```
const pwm_pins = Dict(
    "P9.22" => ("PWM0A", "pwmchip0", "0"),
    "P9.21" => ("PWM0B", "pwmchip0", "1"),
    "P9.14" => ("PWM1A", "pwmchip2", "0"),
    "P9.16" => ("PWM1B", "pwmchip2", "1"),
    "P8.19" => ("PWM2A", "pwmchip4", "0"),
    "P8.13" => ("PWM2B", "pwmchip4", "1"),
)
```

### Changes to the file system
Before the v4.14 kernel, the file system was structured in such a way that, after export, P9.22 could be enabled by writing to the file 
```
/sys/class/pwm/pwmchip0/pwm0/enable
```
however, in the new kernel
```
/sys/class/pwm/pwmchip1/pwm-1:0/enable
```
is used to enable the PWM on the P9.22 pin.

### Testing the PWM pins individually
In order to test the PWM pins from the terminal, make sure that you have added the lines in the /boot/uEnv.txt file, and then configure the desired pin to a PWM pin. For instance, if we wish to control the P9.22 pin, run
```
config-pin P9.22 pwm
```
and make sure that it is configured correctly by running
```
config-pin -q P9.22
```
which should return "P9_22 Mode: pwm". Now you first need to export the correct pin, which, according the the device mapping above, can be done by
```
echo 0 > /sys/class/pwm/pwmchip1/export
```
once this is done, we set a period and duty cycle to the pin
```
echo 1000000000 > /sys/class/pwm/pwmchip1/pwm-1\:0/period
echo 800000000 > /sys/class/pwm/pwmchip1/pwm-1\:0/duty_cycle
```
and enable it through
```
echo 1 > /sys/class/pwm/pwmchip1/pwm-1\:0/enable
```
disable and unexport the PWM pin by
```
echo 0 > /sys/class/pwm/pwmchip1/pwm-1\:0/enable
echo 0 > /sys/class/pwm/pwmchip1/unexport
```
Alternatively, this can be done using the Julia, by writing
```
p = PWM(1)
write!(p, (1, "1"))
write!(p, (2, "1000000000"))
write!(p, (3, "800000000"))
```
