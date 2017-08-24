module LabConnection

    module BeagleBone
        export run_server
        import Base: read
        println("Initializing BB")
        include(joinpath("BeagleBone","BeagleBone.jl"))
        include(joinpath("BeagleBone","precompile.jl"))
        println("Precompiling BB")
        precompile_bb()
        return
    end

    module Computer
        import Base: read, close, get, serialize
        println("Initializing Computer")
        include(joinpath("Computer","Computer.jl"))
    end
end
