To setup automatic start of julia server on the beagle bone
1. Make sure that julia is installed in `/home/debian/julia/bin/julia` on the
BeagleBone or edit `juliaserver.service` accordingly
2. Create the folder `/home/debian/juliapackages/` on the BeagleBone (if it
    doesn't exist already)
3. On the HOST, go to `LabConnections/util` and transfer the latest revision of
the LabConnections package to the BB
4. Run `install.sh` on the BB

After a while, the BeagleBone should start blinking on SysLED 2, with
on-off-on-sleep-repeat. The server should now start automatically on restart of
the BeagleBone.
