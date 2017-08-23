include("../../src/BeagleBone/BeagleBone.jl")

using Base.Test

#Fixture
device = getdev("gpio")
gpio_state = true

@testset "GPIO Tests" begin
    @testset "Error Handling" begin
        # Attempt to initialize faulty device
        @test_throws ErrorException  getdev("wrong_device_name")

        # Test that an exception is thrown when a faulty ID is given
        @test_throws ErrorException write!(device, 100, 1, gpio_state)

        # Test that an exception is thrown when a faulty ID is given
        @test_throws ErrorException write!(device, 0, 1, gpio_state)
    end
    @testset "IO Communication" begin
        # Instanciate all possible leds and perform 10 read/write commands
        # with the set high/low operation (1)
        operation = 1
        for i = 1:10
            for index = 1:length(channels)
                write!(device, index, operation, gpio_state)
            end
            sleep(0.01)
            #for j = 1:4
                #val = read(device, j)
                #@test val == gpio_state
            #end
            gpio_state = !gpio_state
        end
    end
end
