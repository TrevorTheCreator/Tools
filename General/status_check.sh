#!/bin/bash

# v 0.1

#  this script will use curl to return the status code of multiple websites for you


function USAGE () {
  echo
  echo "Usage: status_check.sh [-u FILE] [-h HELP]" >&2
  echo
  echo 'This script will use curl to return the status code of multiple websites for you:'
  echo '    -u check the HTTP status code of domain/url'
  echo '    -h will display this help message'
  echo

}

function STATUS_CHECK () {
	#  need to add a check ifor file existence
	FILE=${OPTARG}

	if [[ -f "${FILE}" ]]
	then
		echo "[!] check will timeout after about 5 seconds"
		echo "[-] return of a 000 status indicates some type of resolution error."
		echo "[-] You can check the error codes on the cURL man page."
		echo

		#  a site may reject/blocklist the curl UA, so this sets a different more 'real' UA string
		#  You could change this as necessary, this is just the UA I chose at random
		UA_STRING="Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0"

		for DOMAINS in $(cat ${FILE})
		do
			#  check will timeout after about 5 seconds
			echo "${DOMAINS}"
			curl -A "${UA_STRING}" -s -o /dev/null --max-time 5.5 -w "%{http_code}\n" "${DOMAINS}"; echo "Error code: ${?}"
			echo
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

while getopts :u:h OPTION
do
	case ${OPTION} in
	u)
		STATUS_CHECK
    	exit 0
		;;
    h)
		USAGE
		exit 0
		;;
	*)
		echo
		echo "[-] Invalid operation"
		USAGE
		exit 0
		;;
	esac
done

#  Remove the options while leaving the arguments
shift "$(( OPTIND - 1 ))"
