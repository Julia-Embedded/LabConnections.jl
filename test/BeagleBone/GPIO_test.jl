using LabConnections.BeagleBone
import LabConnections.BeagleBone: initdev, listdev, closedev, printdev, write!, read, gpio_channels

using Test

@testset "GPIO tests" begin

    @testset "Inialization/Termination" begin
        # Initialize three devices
        initdev("gpio", Int32(1))
        @test sum(listdev()) == 1

        initdev("gpio", Int32(3))
        @test sum(listdev()) == 2

        initdev("gpio", Int32(5))
        @test sum(listdev()) == 3

        #printdev("gpio", 3)

        # Attempt to initialize a device which has already been initialized
        @test_throws ErrorException initdev("gpio", Int32(1))
        @test_throws ErrorException initdev("gpio", Int32(3))
        @test_throws ErrorException initdev("gpio", Int32(5))

        # Attempt to initialize a device with a very high index (no matching channel)
        @test_throws ErrorException initdev("gpio", Int32(1000))

        # Attempt to remove devices which have not been initialized
        @test_throws ErrorException closedev("gpio", Int32(2))
        @test_throws ErrorException closedev("gpio", Int32(4))
        @test_throws ErrorException closedev("gpio", Int32(6))

        #printdev("gpio", 3)

        # Remove devices from TOC
        closedev("gpio", Int32(1))
        @test sum(listdev()) == 2

        closedev("gpio", Int32(3))
        @test sum(listdev()) == 1

        closedev("gpio", Int32(5))
        @test sum(listdev()) == 0

    end

    @testset "Exceptions" begin

        # Fixture
        device = initdev("gpio", Int32(1))

        # Test that an exception is thrown when an invalid operation is given
        # supported operations are 1,2,3
        @test_throws ErrorException write!(device, (Int32(0), "something"))
        @test_throws ErrorException write!(device, (Int32(4), "something"))

        # Test that exceptions are thrown for each individual operation
        @test_throws ErrorException write!(device, (Int32(1), "bad_entry"))
        @test_throws ErrorException write!(device, (Int32(2), "bad_entry"))
        @test_throws ErrorException write!(device, (Int32(3), "bad_entry"))

        # Test operation 3
        @test_throws ErrorException write!(device, (Int32(3), "none"))
        @test_throws ErrorException write!(device, (Int32(3), "rising"))
        @test_throws ErrorException write!(device, (Int32(3), "falling"))
        @test_throws ErrorException write!(device, (Int32(3), "both"))

        # Close Gpio
        closedev("gpio", Int32(1))
    end

    @testset "All channels" begin
        # Configure the GPIO for output usage
        devices = []
        for ii = 1:length(gpio_channels)
            device = initdev("gpio", Int32(ii))
            # Operation 2 -> in/out, set out
            write!(device, (Int32(2), "out"))
            # Append to list
            append!(devices, [device])
        end

        # Sets all available GPIO pins high/low in an alternating pattern
        for i = 1:20
            for ii = 1:length(gpio_channels)
                state = "$(i%2)"
                write!(devices[ii], (Int32(1), state))
                @test read(devices[ii], Int32(1)) == state
            end
            sleep(0.10)
        end

        # Closes all devices
        for ii = 1:length(gpio_channels)
            closedev("gpio", Int32(ii))
        end
    end

    @testset "Read/Write" begin

        # Fixture
        device = initdev("gpio", Int32(1))

        # Test operation 1
        write!(device, (Int32(1), "1"))
        @test read(device, Int32(1)) == "1"
        write!(device, (Int32(1), "0"))
        @test read(device, Int32(1)) == "0"
        write!(device, (Int32(1), "1"))
        @test read(device, Int32(1)) == "1"
        write!(device, (Int32(1), "0"))
        @test read(device, Int32(1)) == "0"

        write!(device, (Int32(2), "in"))
        @test read(device, Int32(2)) == "in"
        write!(device, (Int32(2), "out"))
        @test read(device, Int32(2)) == "out"
        write!(device, (Int32(2), "in"))
        @test read(device, Int32(2)) == "in"
        write!(device, (Int32(2), "out"))
        @test read(device, Int32(2)) == "out"

        # Close Gpio
        closedev("gpio", Int32(1))
    end
end
