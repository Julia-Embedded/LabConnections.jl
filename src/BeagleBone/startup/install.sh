#!/bin/bash
sudo cp /home/debian/juliapackages/LabConnections/src/BeagleBone/startup/juliaserver.service /lib/systemd/system/juliaserver.service
sudo systemctl enable juliaserver
sudo systemctl start juliaserver
