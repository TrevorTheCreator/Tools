#!/bin/bash

#  written by Trevor bloodworth

#  I will probably rarely needs this
#  this script will prepend https:///www. to anything

NUMBER_OF_PARAMETERS="${#}"
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
    echo "This tool will prepend 'https://www.' to URLs that are missing it"
    echo "A file named https_add.txt will be created with your new URLs"
    echo
    echo "Ensure you are reading the file from the same directory as the tool"
    echo "Usage: ${0} [file]"
    echo
  exit 1
fi

#  constant, global variable
readonly FILE=${1}

PREPEND () {
    S1="https://wwww."

    for WORDS in $(cat ${FILE})
    do 
        #  send the output to a secondary file, for easier use in other scripts
        echo ${S1}${WORDS} >> "/home/$USER/Desktop/https_add.txt"
    done
    return 0
}

PREPEND

if [[ ${?} -eq '0' ]]
then
    echo "[+] File 'https_add.txt' is now on your desktop. Please verify your data.'"
else
    echo "[-] An error occurred. Please verify your input file"
    exit 1
fi
