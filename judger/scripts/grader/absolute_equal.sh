#!/bin/bash

source ./judger/scripts/utils/peccho.sh

read -r -d '' INTRO_MSG << EOM
----------------------------
  Grader Name: Absolute Equal
  Grader Version: 0.0.1
----------------------------
EOM

# Params: $1 -> participant output file, $2 -> judge data output file
function do_grading {
  if [ -z $1 ] || [ -z $2 ]; then
    efatal "Missing argument."
    echo "Usage: do_grading <participant output file> <judge data output file>"
    echo
    return 1
  fi

  if [ ! -f $1 ]; then
    efatal "File not found."
    echo "File not found: $1"
    echo
    return 1
  fi

  if [ ! -f $2 ]; then
    efatal "File not found."
    echo "File not found: $2"
    echo
    return 1
  fi

	diff -y <(cat "$1") <(cat "$2") > /dev/null
	if [ $? -ne 0 ]; then
    local diff_parts=$(diff -y <(cat "$1") <(cat "$2"))

    edebug "Outputs diff: <<<EOF---"
    if [ ! -z $DEBUG ]; then
      echo "$diff_parts"
    fi
    edebug "EOF---"
    echo "${RED} ----- WRONG_ANSWER: Output is different to judge.  -----${NORMAL}" 
    return 1
	fi

  echo "${GREEN} ----- ACCEPTED: Outputs match -----${NORMAL}" 
  return 0
}

echo "${CYAN}${INTRO_MSG}${NORMAL}" 