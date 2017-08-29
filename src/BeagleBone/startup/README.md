To setup automatic start of julia server on the beagle bone
1. Make sure that julia is installed in `/home/debian/julia-903644385b/bin/julia` on the BeagleBone or edit `juliaserver.service` accordingly
2. Create the folder `/home/debian/juliapackages/` on the BeagleBone
3. On the computer, go to `LabConnections/util` and run `./copyfoldertobb.sh`
    - If this failes, make sure that there is not already a folder `/home/debian/juliapackages/LabConnections`
1. Copy `LabConnections/src/BeagleBone/startup/juliaserver.service` to `/lib/systemd/system/juliaserver.service` on the BeagleBone.
2. Run: `sudo systemctl enable juliaserver` on BeagleBone
3. Run: `sudo systemctl start juliaserver` on BeagleBone

After a while, the BeagleBone should start blinking on SysLED 2: on-off-on-sleep-repeat

The server should now start automatically on restart of the BeagleBone.
