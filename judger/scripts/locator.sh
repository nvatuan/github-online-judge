#!/bin/bash

# Params: $1 -> File Extension
function set_executor_based_on_file_ext() {
  einfo "Setting executor for file $1"

  case $1 in
    "go")
      einfo "Found: golang"
      source ./judger/scripts/executor/golang.sh
      ;;
    "py")
      echo "py"
      source ./judger/scripts/executor/python.sh
      ;;
    *)
      efatal "Executor for file extension '$1' is not supported."
      exit 1
      ;;
  esac

  einfo "Finish setting executor"
}

GRADER_PATH="./judger/scripts/grader/"

# Params: $1 -> Problem ID OR $CURR_PROBLEM_ID
function set_grader_based_on_problem_id() {
  einfo "Setting grader for problem $CURR_PROBLEM_ID"

  # Read problem descriptor
  if [ $? -ne 0 ]; then
    efatal "Problem descriptor not found. Please make sure you have meta.yaml in your problem directory."
    return 1
  fi

  local grader_name=$(yq '.grader.name' $CURR_PROBLEM_ID/meta.yaml)

  # Check if grader exists
  if [ ! -f "$GRADER_PATH/$grader_name.sh" ]; then
    efatal "Grader '$GRADER_PATH/$grader_name.sh' not found."
    return 1
  fi

  einfo "Problem ${CURR_PROBLEM_ID} uses grader '$grader_name'"
  source "$GRADER_PATH/$grader_name.sh"
}