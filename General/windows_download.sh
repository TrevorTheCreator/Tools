#  this script will download a windows 10 VM for you


function log() {
	#  make value local in scope
	local MESSAGE="${@}"

  echo "${MESSAGE}" >> /Users/trevorbloodworth/Desktop/download_log.$(date +%F)

}

function ERROR_CHECK() {

  if [[ "${?}" -eq '0' ]]
  then
  	log "$(date) : Windows 10 VM downloaded successfully. File should be on your Desktop."
  else
  	log "$(date) : An error occurred during download."
  	exit 1
  fi

}

function DOWNLOAD() {
  #  DOWNLOAD function will self check to ensure the URL is 'up'
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/")
  if [[ ${HTTP_CODE} -eq 200 ]]
  then
    #  use curl to download the File
    UA_STRING="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0"
    #  small concern that this URL may change after so long.
    #  if errors show up in the logs, validate the URL is still good
    curl -A "${UA_STRING}" "https://az792536.vo.msecnd.net/vms/VMBuild_20180102/VirtualBox/IE11/IE11.Win81.VirtualBox.zip" -o /Users/trevorbloodworth/Desktop/IE11.Win81.VirtualBox.zip
  else
    log "$(date) : Site returned a status code not equal to 200. Please validate the URL."
  fi

  return 0

}

DOWNLOAD

ERROR_CHECK
