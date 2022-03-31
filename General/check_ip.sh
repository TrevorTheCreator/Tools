#!/bin/bash

#  This script takes a CSV/TXT file as input and will perform a WHOIS on the IP

# declare function that does all the work
function ASN_CHECK() {
    for IP in $(cat ${FILE})
    do 
        whois -h whois.cymru.com " -v ${IP}"
    done
    return 0
}

NUMBER_OF_PARAMETERS="${#}"

if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
    echo "This tool will perform WHOIS on IP addresses located in the provided text/csv file"
    echo
    echo "This is a IP to ASN mapping tool useful in certain situations."
    echo "Usage: ${0} [file]"
    echo
  exit 1
fi

readonly FILE=${1}

#  check for file existence perform action based on that
if [[ -f "${FILE}" ]]
then
    ASN_CHECK
else
    echo "File '${FILE}' not found. Please try again."
    echo
    exit 1
fi

# end of file error checking
if [[ ${?} -eq '0' ]]
then
    echo
    echo "[+] Completed."
else
    echo "[-] An error occurred. Please verify your input file"
    exit 1
fi
