push!(LOAD_PATH, "/home/debian/juliapackages")
using LabConnections.BeagleBone
BeagleBone.precompile_bb()
server = run_server()
while isopen(server)
    #To keep julia from returning, thus killing the process
    sleep(10)
end
