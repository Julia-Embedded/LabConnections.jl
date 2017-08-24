include("../../src/LabConnection.jl")
using LabConnection.BeagleBone
import LabConnection.BeagleBone: getdev, write!

using Base.Test

#Fixture
device = getdev("sysled")
ledon = true

@testset "SYS LED Tests" begin
    @testset "Error Handling" begin
        # Attempt to initialize faulty device
        @test_throws ErrorException  getdev("wrong_device_name")

        # Test that an exception is thrown when a faulty ID is given
        @test_throws ErrorException write!(device, 5, ledon)

        # Test that an exception is thrown when a faulty ID is given
        @test_throws ErrorException write!(device, 0, ledon)
    end

    @testset "IO Communication" begin
        # Instanciate all possible leds and perform 10 read/write commands
        for i = 1:10
            for j = 1:4
                write!(device, j, ledon)
            end
            sleep(0.001)
            for j = 1:4
                val = read(device, j)
                @test val == ledon
            end
            ledon = !ledon
        end
    end
end
