#BB side
function startbb()
    @async begin
        server = listen(2001)
        while true
            sock = accept(server)
            println("accepted")
            @async while isopen(sock)
                l = deserialize(sock);
                println(typeof(l))
                #print("Read: ");
                println(l);
                serialize(sock,l)
            end
        end
    end
end

#Computer side
clientside = connect(ip"192.168.7.2", 2001)
function getminor(t)
    println(Int64(t))
    t2 = UInt64(floor(UInt64,t/1e9)*1e9)
    tsmall = Int32(t-t2)
end

function runcomp(clientside)
    @async while isopen(clientside)
        l = deserialize(clientside)::Int32;
        #print("Read:");
        t = time_ns()
        #println(t)
        t2 = getminor(t)
        println((t2-l)/1e6)
    end
end
serialize(clientside, getminor(time_ns()))
end # module
