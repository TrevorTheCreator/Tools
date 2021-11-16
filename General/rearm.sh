#!/bin/bash

#  written by Trevor Bloodworth

#  this tool will 'rearm' defanged urls for testing purposes

#  declare functions at beginning

rearm_files() {
  FILE=${OPTARG}

  if [[ -f "${FILE}" ]]
  then
      echo "[+] ${FILE} has been loaded"
      echo "[+] Rearming URLs"
  else
      echo "[-] ${FILE} has not been loaded"
      echo "[-] Please check your spelling."
      exit 1
  fi

  echo
  #  just replacing any [.] with . and any hxxp/s with http/s
  sed -e 's/\[\.]/./g' -e 's/hxxp/http/g' ${FILE}
  echo
  echo "[+] Finished"
  return 0
}

outfile_rearm() {
  #  really this function was created to remove excess input
  #  being appended to the armed_urls.csv file
  FILE=${OPTARG}

  if [[ -f "${FILE}" ]]
  then
      echo
      sed -e 's/\[\.]/./g' -e 's/hxxp/http/g' ${FILE}
      echo
  else
      echo "[-] ${FILE} has not been loaded"
      echo "[-] Please check your spelling."
      exit 1
  fi

  return 0
}

rearm_single() {
  SINGLE=${OPTARG}

  echo "[+] ${SINGLE} has been loaded"
  echo "[+] Rearming URL"

  echo
  echo  ${SINGLE} | sed -e 's/\[\.]/./g' -e 's/hxxp/http/g'
  echo
  echo "[+] Finished"
  return 0
}

outfile() {
  #  function should drop file on user desktop or /home/$USER
  DIRECTORY="/home/$USER/Desktop"
  OUTPUT=${OPTARG}

  if [[ -d "${DIRECTORY}" ]]
  then
    #  if ${DIRECTORY} exists, place file in ${DIRECTORY}/armed.urls.csv
    outfile_rearm >> "${DIRECTORY}/armed_urls.csv"
    echo
    echo '[+] file armed_urls.csv has been created'
  else
    #  if ${DIRECTORY} does NOT exist, place file in /home/$USER/armed_urls.csv}
    outfile_rearm >> "/home/$USER/armed_urls.csv"
    echo
    echo '[+] file armed_urls.csv has been created'
  fi
}


usage() {
  echo
  echo "Usage: rearm.sh [-u URL] [-f FILE] [-o FILE] [-h HELP]" >&2
  echo
  echo 'Rearm defanged URLs:'
  echo '    -u rearm a single URL and dispaly to STDOUT'
  echo '    -f take a file as input and display to STDOUT'
  echo '    -o output csv file to either /home/$USER/Desktop or /home/$USER/'
  echo '    -h will display this help message'
  echo

}

#  meat and potatoes
#  case statement with getops to perform above functions

while getopts :u:f:o:h OPTION
do
	case ${OPTION} in
		u)
			#  take a file as input and perform rearm()
      rearm_single
      exit 0
			;;
    f)
      #  rearm a single URL and dispaly to STDOUT
      rearm_files
      exit 0
      ;;
		o)
			#  output csv file from -f input
      outfile
      exit 0
			;;
		h)
      usage
      exit 0
			;;
		*)
      echo
      echo "[-] Invalid operation"
  		usage
      exit 0
			;;
	esac
done

#  Remove the options while leaving the arguments
shift "$(( OPTIND - 1 ))"
