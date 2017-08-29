#!/bin/bash
###############################################################################
# This line of code connects to the BBB via ssh, runs the startup file and
# remains in the shell of the BBB after executing startup.sh on the BBB
#
# The code may be executed from anywhere on the HOST computer.
###############################################################################
ssh -t debian@192.168.7.2 "./LabConnections.jl/util/startup.sh; bash -l"
