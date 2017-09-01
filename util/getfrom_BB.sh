#!/bin/bash
###############################################################################
# This pice of code attemps to scp files from the BBB to a directory $PWD/temp
#
# The code may be executed from anywhere on the HOST computer.
###############################################################################
{
  if [ ! -d "temp" ]; then
    mkdir temp
  fi
  sudo scp -r debian@192.168.7.2:/home/debian/$1 $PWD/temp
} || {
  echo "Could not find or transfer $1, check that the file exists on the BBB"
}
