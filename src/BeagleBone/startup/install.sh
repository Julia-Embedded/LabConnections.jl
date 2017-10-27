#!/bin/bash
sudo cp LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service
sudo systemctl enable juliaserver
sudo systemctl start juliaserver
