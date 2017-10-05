using LabConnections.BeagleBone
import LabConnections.BeagleBone: getdev, write!, closedev, read, initdev, printdev, listdev

using Base.Test

@testset "SYS LED Tests" begin

    @testset "Inialization/Termination" begin
        # Initialize three devices
        initdev("sysled", 1)
        @test sum(listdev()) == 1

        initdev("sysled", 3)
        @test sum(listdev()) == 2

        # Attempt to initialize a device which has already been initialized
        @test_throws ErrorException initdev("sysled", 1)
        @test_throws ErrorException initdev("sysled", 3)

        # Attempt to initialize a device with a very high index (no matching channel)
        @test_throws ErrorException initdev("sysled", 1000)

        # Attempt to remove devices which have not been initialized
        @test_throws ErrorException closedev("sysled", 2)
        @test_throws ErrorException closedev("sysled", 4)

        # Remove devices from TOC
        closedev("sysled", 1)
        @test sum(listdev()) == 1

        closedev("sysled", 3)
        @test sum(listdev()) == 0
    end

    @testset "Error Handling" begin

        device = initdev("sysled", 1)

        # Test that an exception is thrown when a faulty ID is given
        @test_throws ErrorException write!(device, "bad_entry")

        # Close device
        closedev("sysled", 1)
    end

    @testset "IO Communication" begin
        # Instanciate all possible leds and perform 10 read/write commands
        println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        device1 = initdev("sysled", 1)
        device2 = initdev("sysled", 2)
        device3 = initdev("sysled", 3)
        device4 = initdev("sysled", 4)

        for i = 1:10
            stateA = "$(i%2)"
            stateB = "$((i+1)%2)"
            write!(device1, stateA)
            @test read(device1) == stateA
            write!(device2, stateB)
            @test read(device2) == stateB
            write!(device3, stateA)
            @test read(device3) == stateA
            write!(device4, stateB)
            @test read(device4) == stateB
            sleep(0.1)
        end

        println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        closedev("sysled", 1)
        closedev("sysled", 2)
        closedev("sysled", 3)
        closedev("sysled", 4)
    end
end
