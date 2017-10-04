using LabConnections.BeagleBone
import LabConnections.BeagleBone: getdev, write!, closedev, read, initdev

using Base.Test

@testset "SYS LED Tests" begin
    @testset "Error Handling" begin

        device = initdev("sysled", 1)

        # Test that an exception is thrown when a faulty ID is given
        @test_throws ErrorException write!(device, "bad_entry")

        # Close device
        closedev("sysled", 1)
    end

    @testset "IO Communication" begin
        # Instanciate all possible leds and perform 10 read/write commands
        device1 = initdev("sysled", 1)
        device2 = initdev("sysled", 2)
        device3 = initdev("sysled", 3)
        device4 = initdev("sysled", 4)

        for i = 1:10
            state =
            write!(device1, "$(i%2)")
            write!(device2, "$((i+1)%2)")
            write!(device3, "$(i%2)")
            write!(device4, "$((i+1)%2)")
            sleep(0.1)
        end

        closedev("sysled", 1)
        closedev("sysled", 2)
        closedev("sysled", 3)
        closedev("sysled", 4)
    end
end
