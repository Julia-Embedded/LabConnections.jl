- [`LabConnections.BeagleBone.Debug`](io_devices.md#LabConnections.BeagleBone.Debug)
- [`LabConnections.BeagleBone.GPIO`](io_devices.md#LabConnections.BeagleBone.GPIO)
- [`LabConnections.BeagleBone.IO_Object`](io_devices.md#LabConnections.BeagleBone.IO_Object)
- [`LabConnections.BeagleBone.PWM`](io_devices.md#LabConnections.BeagleBone.PWM)
- [`LabConnections.BeagleBone.SysLED`](io_devices.md#LabConnections.BeagleBone.SysLED)


<a id='Available-devices-1'></a>

# Available devices

<a id='LabConnections.BeagleBone.Debug' href='#LabConnections.BeagleBone.Debug'>#</a>
**`LabConnections.BeagleBone.Debug`** &mdash; *Type*.



```
Debug(i::Int32)
```

Type for debugging and precompile.

<a id='LabConnections.BeagleBone.GPIO' href='#LabConnections.BeagleBone.GPIO'>#</a>
**`LabConnections.BeagleBone.GPIO`** &mdash; *Type*.



```
GPIO(i::Int32)
```

Lowest form of communication with the GPIO pins. The available pins are listed in the "channel" parameter, and appear as directories in /sys/class/gpio after being exported. For instance, to setup a GPIO on "gpio112", configure it as an output pin and set it to high, the following code would be used.

```
gpio = GPIO(1)
write!(gpio, (2,"out"))
write!(gpio, (1, "1"))
```

The operation of reading the current output value of the GPIO is done by

```
read(gpio, 1)
```

See the test/BeagleBone/GPIO_test.jl for more examples.

<a id='LabConnections.BeagleBone.IO_Object' href='#LabConnections.BeagleBone.IO_Object'>#</a>
**`LabConnections.BeagleBone.IO_Object`** &mdash; *Type*.



Define abstract type for pins/LEDS on the BeagleBone

<a id='LabConnections.BeagleBone.PWM' href='#LabConnections.BeagleBone.PWM'>#</a>
**`LabConnections.BeagleBone.PWM`** &mdash; *Type*.



```
PWM(i::Int32)
```

This device allows for low level PWM control of selected pins. The valid pins dictionary pwm_pins relates to memory adresses in of the AM3359 chip, see p.182 in www.ti.com/product/AM3359/technicaldocuments.

<a id='LabConnections.BeagleBone.SysLED' href='#LabConnections.BeagleBone.SysLED'>#</a>
**`LabConnections.BeagleBone.SysLED`** &mdash; *Type*.



```
SysLED(i::Int32)
```

Type representing the system LEDs on the BeagleBone. The LEDs are indexed by i ∈ [1,2,3,4].

