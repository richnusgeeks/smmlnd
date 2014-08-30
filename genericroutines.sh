#! /usr/bin/env bash
############################################################################
# File name : genericroutines.sh
# Purpose : A general purpose routines library for shell utilities.
# Usages  : Source in your bash utilities using . <Path>/genericroutines.sh
# Start date : 21/04/2014
# End date   : dd/mm/2014
# Author : Ankur Kumar <richnusgeeks@gmail.com>
# Download link : https://github.com/richnusgeeks/smmlnd
# License : GNU GPL v3 http://www.gnu.org/licenses/gpl.html
# Version : 0.0.1
# Modification history : 
############################################################################

#set -u
ECHO=$(which echo)
SED=$(which sed)
GREP=$(which grep)

# Prints error/warning/info message and exit/resume.
# Arguments:
#   message
#   message type
#   resume [=exit]
#   color [=no]
# Returns:
#   None
prntErrWarnInfo() {

  local msg="$1"
  local msgtype="$2"
  local extrsme="$3"
  local color="$4"

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

  if [ ! -z "$color" ]
  then
    if [ "$color" != yes ] && [ "$color" != no ]
    then
      printf "\n %s\n" "ERROR: Color option should be yes/no"
      return
    fi

    case "$msgtype" in
      err) msg="\033[31;40;1m$msg\033[m" ;;
      info) msg="\033[32;40;1m$msg\033[m" ;;
      warn) msg="\033[33;40;1m$msg\033[m" ;;
    esac
  fi

  "$ECHO" -e "\n $msg\n"
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
    prntErrWarnInfo "Not proper number of arguments passed" err exit yes
  fi

  if [ -z "$section" ]
  then
    prntErrWarnInfo "No section name provided" err exit yes
  fi

  if [ -z "$field" ]
  then
    prntErrWarnInfo "No field name provided" err exit yes
  fi
  
  if [ -z "$cnfgfl" ]
  then
    prntErrWarnInfo "No config file name provided" err exit yes
  fi

  if [ ! -f "$cnfgfl" ]
  then
    prntErrWarnInfo "No file $cnfgfl found" err exit yes
  fi

  local val=$("$SED" -n "/^ *$section/,/$ *^/p" $cnfgfl | "$GREP" "^ *$field" | "$SED" "s/^ *$field *= *//" | "$SED" 's/ \{1,\}$//')
  printf "%s" "$val"

}
