- [`Base.read`](functions.md#Base.read)
- [`Base.read`](functions.md#Base.read)
- [`Base.read`](functions.md#Base.read)
- [`LabConnections.BeagleBone.assert_pwm_write`](functions.md#LabConnections.BeagleBone.assert_pwm_write-Tuple{Int32,String})
- [`LabConnections.BeagleBone.bbparse`](functions.md#LabConnections.BeagleBone.bbparse-Tuple{Any})
- [`LabConnections.BeagleBone.bbparse`](functions.md#LabConnections.BeagleBone.bbparse-Tuple{Tuple,Any})
- [`LabConnections.BeagleBone.closedev`](functions.md#LabConnections.BeagleBone.closedev-Tuple{String,Int32})
- [`LabConnections.BeagleBone.export_gpio`](functions.md#LabConnections.BeagleBone.export_gpio-Tuple{Int32})
- [`LabConnections.BeagleBone.export_led`](functions.md#LabConnections.BeagleBone.export_led)
- [`LabConnections.BeagleBone.export_pwm`](functions.md#LabConnections.BeagleBone.export_pwm-Tuple{Int32})
- [`LabConnections.BeagleBone.getdev`](functions.md#LabConnections.BeagleBone.getdev-Tuple{String,Int32})
- [`LabConnections.BeagleBone.initdev`](functions.md#LabConnections.BeagleBone.initdev-Tuple{String,Int32})
- [`LabConnections.BeagleBone.listdev`](functions.md#LabConnections.BeagleBone.listdev-Tuple{})
- [`LabConnections.BeagleBone.printdev`](functions.md#LabConnections.BeagleBone.printdev-Tuple{String,Int32})
- [`LabConnections.BeagleBone.run_server`](functions.md#LabConnections.BeagleBone.run_server)
- [`LabConnections.BeagleBone.teardown`](functions.md#LabConnections.BeagleBone.teardown)
- [`LabConnections.BeagleBone.teardown`](functions.md#LabConnections.BeagleBone.teardown)
- [`LabConnections.BeagleBone.teardown`](functions.md#LabConnections.BeagleBone.teardown)
- [`LabConnections.BeagleBone.to_string`](functions.md#LabConnections.BeagleBone.to_string)
- [`LabConnections.BeagleBone.to_string`](functions.md#LabConnections.BeagleBone.to_string)
- [`LabConnections.BeagleBone.to_string`](functions.md#LabConnections.BeagleBone.to_string)
- [`LabConnections.BeagleBone.write!`](functions.md#LabConnections.BeagleBone.write!)
- [`LabConnections.BeagleBone.write!`](functions.md#LabConnections.BeagleBone.write!)
- [`LabConnections.BeagleBone.write!`](functions.md#LabConnections.BeagleBone.write!)


<a id='Available-functions-1'></a>

# Available functions

<a id='LabConnections.BeagleBone.run_server' href='#LabConnections.BeagleBone.run_server'>#</a>
**`LabConnections.BeagleBone.run_server`** &mdash; *Function*.



```julia
run_server(port=2001; debug=false)
```

Run a server on `port` that listens for commands from computer Optional debug keyword disables blinking system leds.

<a id='Base.read' href='#Base.read'>#</a>
**`Base.read`** &mdash; *Function*.



```julia
l = read(led::SysLED, debug::Bool=false)
```

Reads the current brightness value from the LED 'SysLED'.

<a id='Base.read' href='#Base.read'>#</a>
**`Base.read`** &mdash; *Function*.



```julia
l = read(pwm::PWM, operation::Int32, debug::Bool=false)
```

Reads the current value from an operation on a GPIO.

<a id='Base.read' href='#Base.read'>#</a>
**`Base.read`** &mdash; *Function*.



```julia
l = read(gpio::GPIO, operation::Int32, debug::Bool=false)
```

Reads the current value from an operation on a GPIO.

<a id='LabConnections.BeagleBone.assert_pwm_write-Tuple{Int32,String}' href='#LabConnections.BeagleBone.assert_pwm_write-Tuple{Int32,String}'>#</a>
**`LabConnections.BeagleBone.assert_pwm_write`** &mdash; *Method*.



```julia
assert_pwm_write(operation::Int32, entry::String)
```

Assertsion for the PWM input data.

<a id='LabConnections.BeagleBone.bbparse-Tuple{Any}' href='#LabConnections.BeagleBone.bbparse-Tuple{Any}'>#</a>
**`LabConnections.BeagleBone.bbparse`** &mdash; *Method*.



```julia
bbparse(cmd)
```

Parse and execute the command `cmd`.

<a id='LabConnections.BeagleBone.bbparse-Tuple{Tuple,Any}' href='#LabConnections.BeagleBone.bbparse-Tuple{Tuple,Any}'>#</a>
**`LabConnections.BeagleBone.bbparse`** &mdash; *Method*.



```julia
bbparse(l::Tuple, sock)
```

Parse input on the form `l=(iswrite, ndev, cmd1, cmd2, ..., cmdn)` where if `iswrite`     `cmdi = (devname, id, val)`     and if not `iswrite`     `cmdi = (devname, id)` and send back on socket (vals, timestamps).

<a id='LabConnections.BeagleBone.closedev-Tuple{String,Int32}' href='#LabConnections.BeagleBone.closedev-Tuple{String,Int32}'>#</a>
**`LabConnections.BeagleBone.closedev`** &mdash; *Method*.



```julia
closedev(dev_name::String, i::Int32)
```

Closes down a currently active device of type 'dev_name' at index 'i' on the BeagleBone, and removes it from the dict of currently active devices.

<a id='LabConnections.BeagleBone.export_gpio-Tuple{Int32}' href='#LabConnections.BeagleBone.export_gpio-Tuple{Int32}'>#</a>
**`LabConnections.BeagleBone.export_gpio`** &mdash; *Method*.



```julia
export_gpio(i::Int32, debug::Bool=false)
```

Export the GPIO file system, either for real-time or testing usecases.

<a id='LabConnections.BeagleBone.export_led' href='#LabConnections.BeagleBone.export_led'>#</a>
**`LabConnections.BeagleBone.export_led`** &mdash; *Function*.



```julia
export_led(i::Int32, debug::Bool=false)
```

Exports a dummy filesystem for testing the LED implementation

<a id='LabConnections.BeagleBone.export_pwm-Tuple{Int32}' href='#LabConnections.BeagleBone.export_pwm-Tuple{Int32}'>#</a>
**`LabConnections.BeagleBone.export_pwm`** &mdash; *Method*.



```julia
export_gpio(i::Int32, debug::Bool=false)
```

Export the GPIO file system, either for real-time or testing usecases.

<a id='LabConnections.BeagleBone.getdev-Tuple{String,Int32}' href='#LabConnections.BeagleBone.getdev-Tuple{String,Int32}'>#</a>
**`LabConnections.BeagleBone.getdev`** &mdash; *Method*.



```julia
dev = getdev(dev_name::String, i::Int32)
```

Retrieves the active device of type `dev_name` at index 'i'.

<a id='LabConnections.BeagleBone.initdev-Tuple{String,Int32}' href='#LabConnections.BeagleBone.initdev-Tuple{String,Int32}'>#</a>
**`LabConnections.BeagleBone.initdev`** &mdash; *Method*.



```julia
active_device = initdev(dev_name::String, i:Int32)
```

Initializes a new device of type 'dev*name' at index 'i' on the BeagleBone, and adds it to the dict of currently active devices. Returns the initialized device 'active*device'.

<a id='LabConnections.BeagleBone.listdev-Tuple{}' href='#LabConnections.BeagleBone.listdev-Tuple{}'>#</a>
**`LabConnections.BeagleBone.listdev`** &mdash; *Method*.



```julia
message = listdev()
```

Lists all the active devices as an insidence array for testing.

<a id='LabConnections.BeagleBone.printdev-Tuple{String,Int32}' href='#LabConnections.BeagleBone.printdev-Tuple{String,Int32}'>#</a>
**`LabConnections.BeagleBone.printdev`** &mdash; *Method*.



```julia
message = printdev()
```

Prints all the active devices and writes out specifics of a single devices.

<a id='LabConnections.BeagleBone.teardown' href='#LabConnections.BeagleBone.teardown'>#</a>
**`LabConnections.BeagleBone.teardown`** &mdash; *Function*.



```julia
teardown(led::SysLED, debug::Bool=false)
```

Closes all open filestreams for the SysLED 'led'.

<a id='LabConnections.BeagleBone.teardown' href='#LabConnections.BeagleBone.teardown'>#</a>
**`LabConnections.BeagleBone.teardown`** &mdash; *Function*.



```julia
teardown(gpio::GPIO, debug::Bool=false)
```

Closes all open streams on the GPIO, and unexports it from the file system.

<a id='LabConnections.BeagleBone.teardown' href='#LabConnections.BeagleBone.teardown'>#</a>
**`LabConnections.BeagleBone.teardown`** &mdash; *Function*.



```julia
teardown!(pwd::PWM)
```

Closes all open streams on the PWM, and unexports it from the file system

<a id='LabConnections.BeagleBone.to_string' href='#LabConnections.BeagleBone.to_string'>#</a>
**`LabConnections.BeagleBone.to_string`** &mdash; *Function*.



```julia
to_string(led::SysLED, debug::Bool=false)
```

Generates a string representation of the GPIO device.

<a id='LabConnections.BeagleBone.to_string' href='#LabConnections.BeagleBone.to_string'>#</a>
**`LabConnections.BeagleBone.to_string`** &mdash; *Function*.



```julia
to_string(gpio::GPIO, debug::Bool=false)
```

Generates a string representation of the GPIO device.

<a id='LabConnections.BeagleBone.to_string' href='#LabConnections.BeagleBone.to_string'>#</a>
**`LabConnections.BeagleBone.to_string`** &mdash; *Function*.



```julia
to_string(pwm::PWM,, debug::Bool=false)
```

Generates a string representation of the GPIO device.

<a id='LabConnections.BeagleBone.write!' href='#LabConnections.BeagleBone.write!'>#</a>
**`LabConnections.BeagleBone.write!`** &mdash; *Function*.



```julia
write!(gpio::GPIO, args::Tuple{Int32,String}, debug::Bool=false)
```

Writes an entry to an operation on a GPIO, of the form args = (operation, entry).

<a id='LabConnections.BeagleBone.write!' href='#LabConnections.BeagleBone.write!'>#</a>
**`LabConnections.BeagleBone.write!`** &mdash; *Function*.



```julia
write!(led::SysLED, val::Bool, debug::Bool=false)
```

Turns the LED 'SysLed' on/off for val = true/false respectively.

<a id='LabConnections.BeagleBone.write!' href='#LabConnections.BeagleBone.write!'>#</a>
**`LabConnections.BeagleBone.write!`** &mdash; *Function*.



```julia
write!(pwm::PWM, args::Tuple{Int32,String}, debug::Bool=false)
```

Writes an entry to an operation on the PWM, of the form args = (operation, entry).

