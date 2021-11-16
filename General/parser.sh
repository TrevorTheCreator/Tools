#!/bin/bash


#  this script file is used to parse IP, domain, and SHA256 hash IOCs from files given to us from outside intel agencies

NUMBER_OF_PARAMETERS="${#}"
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
    echo "This script file is used to parse IP, domain, and SHA256 hash IOCs from files given to us from outside intel agencies"
    echo
    echo "Ensure you are reading the file from the same directory as the script"
    echo "Usage: ${0} iocFile.txt"
    echo
  exit 1
fi


if [[ -d IOCResults/ ]]
then
    echo "[-] IOCResults/ directory already exists."
    echo "[+] Removing directory and creating a new one."
    rm -rf IOCResults/
    mkdir IOCResults
else
    echo "[+] Creating IOCResults directory for you."
    mkdir IOCResults
fi

IOCFILE=${1}

if [[ -f "${IOCFILE}" ]]
then
    echo "[+] ${IOCFILE} has been loaded"
    echo "[+] Extracting IOCs"
else
    echo "${IOCFILE} has not been loaded"
    echo "Please check your spelling."
    exit 1
fi

#  match on IP address, sort, de-dupe, and dump into csv file
cat $IOCFILE | tr -d '[]' | egrep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | sort | uniq > IOCResults/iocIPAddresses.csv


#  match on domains, sort, de-dupe, and dump into csv file
cat $IOCFILE | tr '[:upper:]' '[:lower:]' | tr -d '[]' | egrep -wo '[-a-zA-Z0-9:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9():%_\+.~#?&//=]*)' | cut -d'/' -f 1 | egrep -v '^c:\\|^%|[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort | uniq > IOCResults/iocDomains.csv


#  match on SHA256 hashes, dump into csv file
cat $IOCFILE | egrep -wo '[0-9A-Za-z]{64}' | tr '[:lower:]' '[:upper:]' > IOCResults/iocSHA256Hashes.csv


echo "[+] Script has finished"
echo "[+] Please validate your data!"
exit 0
