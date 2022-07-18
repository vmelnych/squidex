#!/bin/bash

# Error handling
set -o errexit          # Exit on most errors
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o nounset          # Exits if any of the variables is not set

#folder where the current script is located
declare HOME="$(cd "$(dirname "$0")"; pwd -P)"
declare today=$(date +"%Y%m%d")

# colors
GRN='\033[0;32m'
YEL='\033[1;33m'
RED='\033[0;31m'
BLU='\033[0;34m'
NC='\033[0m'

declare env=".env"

##reading .env parameters from the script folder
if [ ! -r $env ]; then
  printf "Missing config file ${RED}$env${NC} in the folder ${RED}$HOME${NC}. Fix it and try again.\n"
  exit 1
else
  source $env
fi

main() {
    case "${1}" in
        --backup | -b )
            if [ -d "${EXT_BACKUP}" ]; then
              if [ ! -z "$2" ]; then
                docker exec -it ${MONGO_CONTAINER} bash -c "mongodump --db ${2} --gzip --out=${INT_BACKUP}/${today}"
                printf "dump files for database ${GRN}${2}${NC} are stored in ${GRN}${HOME}/${EXT_BACKUP}/${today}${NC} !\n"
              else
                printf "${RED}Missing database name!${NC}\n"
              fi
            else
              printf "${RED}Backup folder ${BLU}${EXT_BACKUP}${RED} does not exist!${NC}\n"
            fi
           ;;
        --up | -u )
            docker-compose up -d "${@:2}"
            ;;
        --down | -d )
            docker-compose down
            ;;
        --restart | -r )
            docker-compose down
            docker-compose up -d "${@:2}"
            ;;
        --restore )
            if [ -d "${EXT_BACKUP}" ]; then
              if [ ! -z "$2" ] && [ ! -z "$3" ] && [ -d "${EXT_BACKUP}"/"$3" ]; then
                printf "${RED} RESTORE STARTED ${NC}\n"
                docker exec -it ${MONGO_CONTAINER} bash -c "mongorestore --nsInclude '${2}.*' --gzip --drop ${INT_BACKUP}/${3}"
                printf "${RED} RESTORE FINISHED ${NC}\n"
               else
                printf "${RED}Missing database name, folder name or the folder does not exist!${NC}\n"
              fi
            else
              printf "${RED}Backup folder ${BLU}${EXT_BACKUP}${RED} does not exist!${NC}\n"
            fi
            ;;
        * ) 
            printf "usage: ${0} [arg]\n \
                    $GRN--backup,-b$NC\t Back-up the database. 2nd argument is a database name.\n \
                    $GRN--up,-u$NC\t\t Up the repo.\n \
                    $GRN--down,-d$NC\t\t Down the repo.\n \
                    $GRN--restart,-r$NC\t Cold-restart the repo.\n \
                    $GRN--restore$NC\t\t Restore the database. 2nd argument is a database name and 3rd is a folder with backup (inside $GRN${EXT_BACKUP}$NC)!\n"
            ;;
    esac

}

time main "$@"
