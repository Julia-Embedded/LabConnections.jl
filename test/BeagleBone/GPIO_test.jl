include("../../src/LabConnection.jl")
using LabConnection.BeagleBone
import LabConnection.BeagleBone: getdev, write!, channels

using Base.Test

#Fixture
device = getdev("gpio")
gpio_state = true
write!(device, 31, (2, "out"))

device = getdev("gpio")

@testset "GPIO Tests" begin
    @testset "Error Handling" begin
        # Attempt to initialize faulty device
        @test_throws ErrorException  getdev("wrong_device_name")

        # Test that an exception is thrown when a faulty channel is given
        @test_throws ErrorException write!(device, 100, (1, "0"))

        # Test that an exception is thrown when a faulty channel is given
        @test_throws ErrorException write!(device, 0, (1, "1"))

        # Test that an exepition is thrown when requiring bad entry
        @test_throws ErrorException write!(device, 0, (123, "0"))

        # Test that an exepition is thrown when requiring bad entry
        @test_throws ErrorException write!(device, 0, (1, "bad_entry"))
    end
    @testset "IO Communication" begin
        # Instanciate all possible leds and perform 10 read/write commands
        # with the set high/low operation (1)
        operation = 1
        for i = 1:10
            state = "$(i%2)"
            for index = 1:length(channels)
                write!(device, index, (operation, state))
            end
            sleep(0.1)
        end
    end
end
