
<a id='Testing-1'></a>

# Testing


Scripts for testing the code in `LabConnections.jl` are found under `/test`. The test-sets under `/test/BeagleBone` can be run on any computer (i.e not only on a real BeagleBone (BB)), regardless of their file system. By setting the flag RUNNING_TESTS to true, a dummy file-system is exported in which the tests are run. This has the advantage of enabling testing of the code run on the BB free from the BB itself, without building the Debian file system, thereby enabling the automatic testing through Travis.


To run the tests, simply navigate to the `/test` directory and run


```
julia runtests.jl
```


If the tests are to be run on the BB with hardware in the loop, SSH into the BB and run the tests from a local Julia REPL


```
push!(LOAD_PATH, "/home/debian/juliapackages")
using LabConnections
include("/home/debian/juliapackages/LabConnections/test/runtests.jl")
```

