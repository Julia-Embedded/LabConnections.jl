function precompile_bb()
    #Start server
    server = run_server(3001, debug=true)

    #Pretend to be Computer
    clientside = connect(3001)

    #Precompile serialize
    initdev("debug", Int32(1))

    serialize(clientside, (WRITE, Int32(2), ("debug", Int32(1), true), ("debug", Int32(1), (1,2.0,"asd"))))
    serialize(clientside, (WRITE, Int32(2), ("debug", Int32(1), Int32(1)), ("debug", Int32(1), 1.0)))
    serialize(clientside, (READ, Int32(2),    ("debug", Int32(1)), ("debug", Int32(1))))

    serialize(clientside, (WRITE, Int32(1), ("debug", Int32(1), true)))
    serialize(clientside, (READ, Int32(1), ("debug", Int32(1))))
    initdev("debug", Int32(2))
    initdev("debug", Int32(3))
    initdev("debug", Int32(4))
    serialize(clientside, (WRITE, Int32(4), ("debug", Int32(1), true), ("debug", Int32(2), false), ("debug", Int32(3), true), ("debug", Int32(4), false)))

    closedev("debug", Int32(1))
    closedev("debug", Int32(2))
    closedev("debug", Int32(3))
    closedev("debug", Int32(4))

    println("closing clientside")
    # Close the client side
    close(clientside)

    println("closing server")
    #Close server
    close(server)

    debug = true
    println("initdev")
    #Precompile SysLED
    led = initdev("sysled",Int32(1))
    write!(led, "1", debug)
    read(led, debug)
    println("closedev")
    closedev("sysled", Int32(1))

    ind = 1
    println("False: $(ind ∉ [1,2,3,4])")

    # Precompile GPIO
    gpio = initdev("gpio",Int32(1))

    write!(gpio, (Int32(1), "1"), debug)
    closedev("gpio", Int32(1))
    #read(gpio, ind, args, debug)

    # TODO activate when pwn is working
    # Precompile PWM
    #pwm = initdev("pwm", Int32(1))
    #write!(pwm, (Int32(1),"1"), debug)

    #Do read/write to file
    val = true
    testfile = joinpath(@__DIR__,"startup/testfile.txt")
    file = open(testfile, "r+")
    write(file, val ? "1" : "0")
    close(file)

    file = open(testfile, "r")
    l = readline(file)
    close(file)

    try getdev("nonexistent")       catch end
    try bbparse("Invalid input")    catch end
    try bbparse(("Invalid input"))  catch end

    println("Internal Precompile Finished")
end
