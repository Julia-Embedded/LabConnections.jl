using LabConnections.BeagleBone
import LabConnections.BeagleBone: initdev, listdev, closedev, printdev, write!, read!

using Base.Test

@testset "GPIO Inialization and termination" begin
    # Initialize three devices
    initdev("gpio", 1)
    @test sum(listdev()) == 1

    initdev("gpio", 3)
    @test sum(listdev()) == 2

    initdev("gpio", 5)
    @test sum(listdev()) == 3

    #printdev("gpio", 3)

    # Attempt to initialize a device which has already been initialized
    @test_throws ErrorException initdev("gpio", 1)
    @test_throws ErrorException initdev("gpio", 3)
    @test_throws ErrorException initdev("gpio", 5)

    # Attempt to initialize a device with a very high index (no matching channel)
    @test_throws ErrorException initdev("gpio", 1000)

    # Attempt to remove devices which have not been initialized
    @test_throws ErrorException closedev("gpio", 2)
    @test_throws ErrorException closedev("gpio", 4)
    @test_throws ErrorException closedev("gpio", 6)

    #printdev("gpio", 3)

    # Remove devices from TOC
    closedev("gpio", 1)
    @test sum(listdev()) == 2

    closedev("gpio", 3)
    @test sum(listdev()) == 1

    closedev("gpio", 5)
    @test sum(listdev()) == 0

end

@testset "GPIO Read and write" begin

    # Fixture
    device = initdev("gpio", 1)

    # Test that an exception is thrown when an invalid operation is given
    # supported operations are 1,2,3
    @test_throws ErrorException write!(device, (0, "something"))
    @test_throws ErrorException write!(device, (4, "something"))

    # Test that exceptions are thrown for each individual operation
    @test_throws ErrorException write!(device, (1, "bad_entry"))
    @test_throws ErrorException write!(device, (2, "bad_entry"))
    @test_throws ErrorException write!(device, (3, "bad_entry"))

    # Test operation 1
    sleep(0.001);write!(device, (1, "1"))
    sleep(0.001);@test read(device, 1) == "1"
    sleep(0.001);write!(device, (1, "0"))
    sleep(0.001);@test read(device, 1) == "0"
    sleep(0.001);write!(device, (1, "1"))
    sleep(0.001);@test read(device, 1) == "1"
    sleep(0.001);write!(device, (1, "0"))
    sleep(0.001);@test read(device, 1) == "0"

    if false
        # TODO fix write function to clear files before writing otherwise writing "xy" when a file containt "abcd" results in "xycd" and a system failure
        # Test operation 2
        sleep(0.001);write!(device, (2, "in"))
        sleep(0.001);@test read(device, 2) == "in"
        sleep(0.001);write!(device, (2, "out"))
        sleep(0.001);@test read(device, 2) == "out"
        sleep(0.001);write!(device, (2, "in"))
        sleep(0.001);@test read(device, 2) == "in"
        sleep(0.001);write!(device, (2, "out"))
        sleep(0.001);@test read(device, 2) == "out"

        # Test operation 3
        sleep(0.001);write!(device, (3, "none"))
        sleep(0.001);@test read(device, 3) == "none"
        sleep(0.001);write!(device, (3, "rising"))
        sleep(0.001);@test read(device, 3) == "rising"
        sleep(0.001);write!(device, (3, "falling"))
        sleep(0.001);@test read(device, 3) == "falling"
        sleep(0.001);write!(device, (3, "both"))
        sleep(0.001);@test read(device, 3) == "both"
    end

    # Close Gpio
    closedev("gpio", 1)
 end

@testset "IO Communication" begin
    # Instanciate all possible leds and perform 10 read/write commands
    # with the set high/low operation ("value")

    # Configure the GPIO for output usage
    device = initdev("gpio", 1)

    # Operation 2 -> in/out, set out
    write!(device, (2, "out"))

    # Configure the GPIO for output usage
    for i = 1:10
        state = "$(i%2)"
        sleep(0.10);write!(device, (1, state))
        sleep(0.001);@test read(device, 1) == state
    end
    closedev("gpio", 1)
end
