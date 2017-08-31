using LabConnections.BeagleBone
import LabConnections.BeagleBone: getdev, write!, channels

using Base.Test

#Fixture
device = getdev("gpio")
gpio_state = true
write!(device, 1, ("direction", "out"))

device = getdev("gpio")

@testset "GPIO Tests" begin
    @testset "Error Handling" begin
        # Attempt to initialize faulty device
        @test_throws ErrorException  getdev("wrong_device_name")

        # Test that an exception is thrown when a too high pin-index is given
        @test_throws ErrorException write!(device, Int32(100), ("value", "0"))
        @test_throws ErrorException read(device, Int32(100),"value")

        # Test that an exception is thrown when a too low pin-index is given
        @test_throws ErrorException write!(device, Int32(0), ("value", "1"))
        @test_throws ErrorException read(device, Int32(0), "value")

        # Test that an exception is thrown when requesting a bad operation
        @test_throws ErrorException write!(device, Int32(1), ("bad_operation", "0"))
        @test_throws ErrorException read(device, Int32(1),"bad_operation")

        # Test that an exception is thrown when writing a bad entry
        @test_throws ErrorException write!(device, Int32(1), ("value", "bad_entry"))
    end
    @testset "IO Communication" begin
        # Instanciate all possible leds and perform 10 read/write commands
        # with the set high/low operation ("value")
        operation = "value"
        for i = 1:10
            state = "$(i%2)"
            for index = 1:length(channels)
                write!(device, Int32(index), (operation, state))
            end
            sleep(0.1)
        end
    end
end
