using Base.Test

# This flag is enabled if a dummy filesystem should be used for testing (for online testing)
# disabling the flag allows the BBB to be run in the loop, in this case blinking LEDS
RUNNING_TESTS = true

include("BeagleBone/GPIO_test.jl")
include("BeagleBone/PWM_test.jl")
