#!/bin/bash

# Import colors
source ./judger/scripts/constants/colors.sh

## Pretty echo

function edebug {
  if [ -z $DEBUG ]; then
    return
  fi
  echo "${MAGENTA}[DEBUG]---${NORMAL} $1"
}

function einfo {
  echo "${CYAN}[INFO]${NORMAL} $1"
}

function esucceed {
  echo "${GREEN}[OK]${NORMAL} $1"
}

function ewarn {
  echo "${YELLOW}[WARN]${NORMAL} $1"
}

function efatal {
  echo "${RED}[FATAL]${NORMAL} $1"
}

function efail {
  echo "${RED}[FAIL]${NORMAL} $1"
}

if [ "$DEBUG" = "true" ]; then
  edebug "DEBUG is set"
fi
