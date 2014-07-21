#! /usr/bin/env bash
############################################################################
# File name : genericroutines.sh
# Purpose : A general purpose routines library for shell utilities.
# Usages  : 
# Start date : 21/04/2014
# End date   : dd/mm/2014
# Author : None
# Download link : http://www.Ankur-Satellite-L755.com
# License : GNU GPL v3 http://www.gnu.org/licenses/gpl.html
# Version : 0.0.1
# Modification history : 
############################################################################

# Prints error/warning/info message and exit/resume.
# Arguments:
#   message
#   message type
#   resume
# Returns:
#   None
prntErrWarnInfo() {

  local msg="$1"
  local msgtype="$2"
  local extrsme="$3"

  if [ -z "$msg" ]; then
    printf "\n %s\n" "ERROR: No message provided"
    return
  fi

  if [ -z "$msgtype" ]; then
    msgtype='err'
  fi

  if [ -z "$extrsme" ]; then
    extrsme='exit'
  fi

  case "$msgtype" in 
    info) msg="INFO: $msg" ;;
    warn) msg="WARNING: $msg" ;;
    err)  msg="ERROR: $msg" ;;
    *)
      printf "\n %s\n" "ERROR: Message type should be info/warn/err"
      return
      ;;
  esac

  printf "\n %s\n" "$msg"
  if [ "$extrsme" = "exit" ]; then
    printf " %s\n" "exiting ..."
    exit 1
  fi

}

# Parses field = value entries under a section from a text file.
# Arguments:
#   section
#   field
#   config file
# Returns:
#   value
getValFrmCnfg() {

  local section="$1"
  local field="$2"
  local cnfgfl="$3"

  if [ $# -ne 3 ]
  then
    prntErrWarnInfo "Not proper number of arguments passed" 
  fi

  if [ -z "$section" ]
  then
    prntErrWarnInfo "No section name provided"
  fi

  if [ -z "$field" ]
  then
    prntErrWarnInfo "No field name provided"
  fi
  
  if [ -z "$cnfgfl" ]
  then
    prntErrWarnInfo "No config file name provided"
  fi

  if [ ! -f "$cnfgfl" ]
  then
    prntErrWarnInfo "No file $cnfgfl found"
  fi

  local val=$(sed -n "/^ *$section/,/$ *^/p" $cnfgfl | grep "^ *$field" | sed "s/^ *$field *= *//" | sed 's/ \{1,\}$//')
  printf "%s" "$val"

}

