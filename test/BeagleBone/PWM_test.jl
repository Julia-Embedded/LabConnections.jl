using LabConnections.BeagleBone
import LabConnections.BeagleBone: initdev, listdev, closedev, printdev, write!, read, pwm_pins

using Base.Test

@testset "PWM tests" begin

    @testset "Inialization/Termination" begin
        # Initialize three devices
        initdev("pwm", Int32(1))
        @test sum(listdev()) == 1

        initdev("pwm", Int32(3))
        @test sum(listdev()) == 2

        initdev("pwm", Int32(5))
        @test sum(listdev()) == 3

        #printdev("gpio", 3)

        # Attempt to initialize a device which has already been initialized
        @test_throws ErrorException initdev("pwm", Int32(1))
        @test_throws ErrorException initdev("pwm", Int32(3))
        @test_throws ErrorException initdev("pwm", Int32(5))

        # Attempt to initialize a device with a very high index (no matching channel)
        @test_throws ErrorException initdev("pwm", Int32(1000))

        # Attempt to remove devices which have not been initialized
        @test_throws ErrorException closedev("pwm", Int32(2))
        @test_throws ErrorException closedev("pwm", Int32(4))
        @test_throws ErrorException closedev("pwm", Int32(6))

        #printdev("gpio", 3)

        # Remove devices from TOC
        closedev("pwm", Int32(1))
        @test sum(listdev()) == 2

        closedev("pwm", Int32(3))
        @test sum(listdev()) == 1

        closedev("pwm", Int32(5))
        @test sum(listdev()) == 0

    end

    @testset "Read/Write" begin

        # Fixture
        device = initdev("pwm", Int32(1))

        # Test that an exception is thrown when an invalid operation is given
        # supported operations are 1,2,3,
        @test_throws ErrorException write!(device, (Int32(0), "something"))
        @test_throws ErrorException write!(device, (Int32(5), "something"))

        # Test thet exceptions are thrown when attempting to write faulty entries
        @test_throws ErrorException write!(device, (Int32(1), "-1"))
        @test_throws ErrorException write!(device, (Int32(1), "bad_entry"))
        @test_throws ErrorException write!(device, (Int32(2), "-1"))
        @test_throws ErrorException write!(device, (Int32(2), "100000001"))
        @test_throws ErrorException write!(device, (Int32(2), "bad_entry"))
        @test_throws ErrorException write!(device, (Int32(3), "-1"))
        @test_throws ErrorException write!(device, (Int32(3), "100000001"))
        @test_throws ErrorException write!(device, (Int32(3), "bad_entry"))
        @test_throws ErrorException write!(device, (Int32(4), "-1"))
        @test_throws ErrorException write!(device, (Int32(4), "100000001"))
        @test_throws ErrorException write!(device, (Int32(4), "bad_entry"))

        # Close Gpio
        closedev("pwm", Int32(1))
     end

    @testset "All pins" begin
        # Instanciate all possible leds and perform 10 read/write commands
        # with the set high/low operation ("value")

        # Configure the GPIO for output usage
        devices = []
        for ii = 1:length(pwm_pins)
            device = initdev("pwm", Int32(ii))
            # Operation 2 -> in/out, set out
            write!(device, (Int32(2), "100000000"))
            @test read(device, Int32(2)) == "100000000"
            write!(device, (Int32(3), "50000000"))
            @test read(device, Int32(3)) == "50000000"
            write!(device, (Int32(1), "1"))
            @test read(device, Int32(1)) == "1"
            # Append to list
            append!(devices, [device])
        end

        @test sum(listdev()) == 6

        sleep(1.0)

        # Closes all devices
        for ii = 1:length(pwm_pins)
            write!(devices[ii], (Int32(1), "0"))
            closedev("pwm", Int32(ii))
        end
        @test sum(listdev()) == 0
    end

end
