#!/bin/bash

#  v 0.1
#  written by Trevor Bloodworth
#  script reads a list of domains and runs whois on them, returning condensed information


function USAGE () {
  echo
  echo 'Usage: get_whois.sh [-f FILE] [-h HELP]' >&2
  echo
  echo 'This script will run whois on a list of domain names and return condensed information.'
  echo 'Elements in the list should look like example.com, or text.com. No http/s'
  echo '    -f file to read from'
  echo '    -h will display this help message'
  echo

}

function GET_WHOIS () {
	FILE=${OPTARG}

	if [[ -f "${FILE}" ]]
	then
		echo "[!] Reading from ${FILE}"
    echo

		for DOMAINS in $(cat ${FILE})
		do
      echo "[+] Domain : ${DOMAINS}"
      # pipe to awk just removes leading and trailing whitespaces
      whois "${DOMAINS}" | grep -Ei ' Registrar:| Creation Date:| Updated Date|Registrant Country:' | awk '{$1=$1};1'
      echo
    done
    return 0
  else
    echo "[-] ${FILE} not found."
    echo "[-] Please check your spelling."
    exit 1
  fi

  return 0
}

while getopts :f:h OPTION
do
	case ${OPTION} in
	f)
		GET_WHOIS
   	exit 0
		;;
  h)
    USAGE
    exit 0
    ;;
	*)
		echo
		echo "[-] Invalid operation"
		echo
		USAGE
		exit 0
		;;
	esac
done

#  Remove the options while leaving the arguments
shift "$(( OPTIND - 1 ))"
