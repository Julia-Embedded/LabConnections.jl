__precompile__()
module LabConnections

    module BeagleBone
        RUNNING_TESTS = false # TODO Can we make this constant?
        function running_test(val)
            global RUNNING_TESTS = val
        end
        using Sockets, Serialization
        export run_server
        import Base: read
        println("Initializing BB")
        include(joinpath("BeagleBone","BeagleBone.jl"))
        include(joinpath("BeagleBone","precompile.jl"))
        println("Precompiling BB")
        #precompile_bb()
        return
    end

    module Computer
        using Sockets, Serialization
        import Base: read, close, get, put!
        import Sockets: send
        import Serialization: serialize
        println("Initializing Computer")
        include(joinpath("Computer","Computer.jl"))
    end
end
