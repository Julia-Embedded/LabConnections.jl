function precompile_bb()
    #Start server
    server = run_server(3001, debug=true)

    #Pretend to be Computer
    clientside = connect(3001)

    #Precompile serialize
    serialize(clientside, (true, Int32(2), ("debug", Int32(1), true), ("debug", Int32(1), (1,2.0,"asd"))))
    serialize(clientside, (true, Int32(2), ("debug", Int32(1), Int32(1)),
                                    ("debug", Int32(1), 1.0)))
    serialize(clientside, (false, Int32(2),    ("debug", Int32(1)),
                                        ("debug", Int32(1))))
    serialize(clientside, (true, Int32(1), ("debug", Int32(1), true)))
    serialize(clientside, (false, Int32(1), ("debug", Int32(1))))
    serialize(clientside, (true, Int32(4), ("debug", Int32(1), true), ("debug", Int32(2), false),
                            ("debug", Int32(3), true), ("debug", Int32(4), false)))

    close(clientside)
    #Close server
    close(server)

    debug = true
    #Precompile SysLED
    led = SysLED()
    write!(led, Int32(1), true, debug)
    read(led, Int32(1), debug)

    ind = 1
    println("False: $(ind ∉ [1,2,3,4])")

    # Precompile GPIO
    gpio = GPIO()
    write!(gpio, Int32(1), ("value", "1"), debug)
    #read(gpio, ind, args, debug)

    #Do read/write to file
    val = true
    testfile = joinpath(@__DIR__,"startup/testfile.txt")
    file = open(testfile, "r+")
    write(file, val ? "1" : "0")
    close(file)

    file = open(testfile, "r")
    l = readline(file)
    close(file)
    println("Read from file: $l")

    try getdev("nonexistent")       catch end
    try bbparse("Invalid input")    catch end
    try bbparse(("Invalid input"))  catch end

    println("Internal Precompile Finished")
end
