#!/bin/bash
#Run in this file un util folder, copies to BB
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BASEDIR=../$(dirname "$0")

# store arguments in a special array
args=("$@")
# get number of elements
numberOfArguments=${#args[@]}
echo $ELEMENTS
# echo each element in array
# for loop
#for (( i=0;i<$ELEMENTS;i++)); do
#   echo ${args[${i}]}
#done

if [ ${#args[@]} == 0 ]
then
  printf "${RED}ABORTING.${NC} No directory provided\n"
else
  for (( i=0;i<$numberOfArguments;i++)); do
    if [ -d $BASEDIR/${args[${i}]} ]
    then
      printf "${GREEN}Copying $BASEDIR/${args[${i}]} to BB${NC}\n"
      scp -r $BASEDIR/${args[${i}]} debian@192.168.7.2:/home/debian/juliapackages/LabConnections/${args[${i}]}
    else
      printf "${RED}ABORTING.${NC} The provided directory $BASEDIR/${args[${i}]} does not exist\n"
    fi
  done
fi
