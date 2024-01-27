#!/bin/bash

source ./judger/scripts/utils/peccho.sh
read -r -d '' INTRO_MSG << EOM
----------------------------
  Grader Name: Hoge
  Grader Version: 0.0.1
----------------------------
EOM

function do_grading {
  echo "${GREEN} ----- ACCEPTED: Hoge Ooke -----${NORMAL}" 
  return 0
}

echo "${CYAN}${INTRO_MSG}${NORMAL}" 