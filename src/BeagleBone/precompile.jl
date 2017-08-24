function precompile_bb()
    #Start server
    server = run_server(3001)

    #Pretend to be Computer
    clientside = connect(3001)

    #Precompile serialize
    serialize(clientside, (true, Int32(1), ("debug", Int32(1), true), ("debug", Int32(1), (1,2.0,"asd"))))
    serialize(clientside, (true, Int32(2), ("debug", Int32(1), Int32(1)),
                                    ("debug", Int32(1), 1.0)))
    serialize(clientside, (false, Int32(2),    ("debug", Int32(1)),
                                        ("debug", Int32(1))))


    close(clientside)
    #Close server
    close(server)

    debug = true
    #Precompile SysLED
    led = SysLED()
    write!(led, Int32(1), true, debug)
    read(led, Int32(1), debug)

    # Precompile GPIO
    gpio = GPIO()
    write!(gpio, Int32(1), (Int32(2), "1"), debug)
    #read(gpio, ind, args, debug)

    try getdev("nonexistent")       catch end
    try bbparse("Invalid input")    catch end
    try bbparse(("Invalid input"))  catch end
end
