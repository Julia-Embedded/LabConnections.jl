#!/bin/bash
###############################################################################
# This code clones or upps the most recent code from github and transfers it to
# the BBB before connecting to it and running the startup file on the BBB.
#
# The code may be executed from anywhere on the HOST computer.
###############################################################################

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

printf "${BLUE}Updating project${NC}\n..."

codeHost=gitlab.control.lth.se
codeUser=labdev
projects=(LabConnections.jl)
flag=false

for project in "${projects[@]}"; do
  {
    if [ -d "${project}" ]; then
      # Try to clone repository
      printf "${GREEN}Pulling /${project}...${NC}\n"
      cd "${project}"
      echo $(ls)
      git pull "https://${codeHost}/${codeUser}/${project}.git"
      cd ".."
    else
      printf "${GREEN}Cloning /${project}...${NC}\n"
      git clone "https://${codeHost}/${codeUser}/${project}.git"
    fi
  } || { # catch
    # save log for exception
    flag=false
    printf "${RED}Could not udate repository /${project}${NC}, aborting.\n"
  }
done

printf "${BLUE}Initializing Transferring files to BBB${NC}\n"
if [ "{flag}"=true ]; then
  for project in "${projects[@]}"; do
    {
      printf "${GREEN}Transferring /${project}...${NC}\n"
      scp -r ${project} debian@192.168.7.2:/home/debian
    } || { # catch
      # save log for exception
      flag=false
      printf "${RED}Could not send project /${project} to the BBB, aborting!${NC}\n"
    }
  done
fi

printf "${BLUE}Deleting temporary files...${NC}\n"
for project in "${projects[@]}"; do
  {
    rm -rf ${project}
  } || {
    printf "${RED}Could not delete project /${project}, aborting!${NC}\n"
}
done

printf "${BLUE}Connecting to the BBB...${NC}\n"
{
  ssh -t debian@192.168.7.2 "./LabConnections.jl/util/startup.sh; bash -l"
} || {
   printf "${RED}Could Connect to the BBB!${NC}\n"
}
