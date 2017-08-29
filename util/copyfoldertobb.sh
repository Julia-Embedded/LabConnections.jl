#Run in this file un util folder, copies to BB
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

printf "${BLUE}Updating project${NC}\n..."

codeHost=gitlab.control.lth.se
codeUser=labdev
projects=LabConnections
flag=false

printf "${BLUE}Initializing Transferring files to BBB${NC}\n"
if [ "{flag}"=true ]; then
  for project in "${projects[@]}"; do
    {
      printf "${GREEN}Transferring /${project}...${NC}\n"
      printf "scp -r ../../${project} debian@192.168.7.2:/home/debian"
      scp -r ../../${project} debian@192.168.7.2:/home/debian
    } || { # catch
      # save log for exception
      flag=false
      printf "${RED}Could not send folder /${project} to the BBB, aborting!${NC}\n"
    }
  done
fi
