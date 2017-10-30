#!/bin/bash
#Run in this file un util folder, copies to BB
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BASEDIR=../../$(dirname "$0")

# Dependencies
# LabConnections - main repository
# serbus - a fork of a SPI communicaiton interface
packages=(LabConnections serbus)

# Create an empty directory to bundle packages
if [ -d ${BASEDIR}/juliapackages ]; then
  rm -rf ${BASEDIR}/juliapackages
fi
mkdir ${BASEDIR}/juliapackages

# Copy packets to the juliapackages directory
flag=true
printf "${GREEN}Bundling...${NC}\n\n"
for (( i=0; i<${#packages[@]}; i++ )); do
  {
    printf "${BLUE}    * ${packages[$i]}${NC}\n"
    cp -r ../../${packages[$i]} ${BASEDIR}/juliapackages
  } || {
    printf "${BLUE}WARNING.${NC} Could not bundle package ${packages[$i]}${NC}\n"
    flag=false
  }
done

# Transfer files
if [ "$flag" = true ] ; then
  {
    printf "\n${GREEN}Transferring files...${NC}"
    scp -r ${BASEDIR}/juliapackages debian@192.168.7.2:/home/debian
    printf "${GREEN}...complete!${NC}\n"
  } || {
    printf "${RED}ABORTING.${NC} All packets could not be transferred, remove /home/debian/juliapackages on the BBB.\n"
  }
else
    printf "${RED}ABORTING.${NC} All packets could not be budled, check their existence on the HOST\n"
fi

# Remove temporary directory
rm -rf ${BASEDIR}/juliapackages
