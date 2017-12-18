push!(LOAD_PATH, "/home/debian/juliapackages")
using LabConnections.BeagleBone
BeagleBone.precompile_bb()
server = run_server()
println("Opening server")
while isopen(server)
    #To keep julia from returning, thus killing the process
    println("server kept open")
    sleep(10)
end
