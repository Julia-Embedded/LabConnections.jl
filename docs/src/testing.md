# Tests
The BeagleBone tests can be run on any computer, regrdless of their file-syste.
By setting the flag RUNNING_TESTS to true, a dummy file-system is exported in
which the tests are run operate. This has the advantage of enabling testing of
the code run on the BB free from the BB itself, without building the Debian FS,
thereby enabling the automatic testing through Travis.

To run the tests, simply enter the /test/ directory and run

    julia run_tests.jl

If the tests are to be run on the BB with hardware in the loop, run

    julia run_tests.jl

on the BB, to run examples separately, see
