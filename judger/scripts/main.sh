#!/bin/bash

## Import utils
### Pretty echo
source ./judger/scripts/utils/peccho.sh

### Directory
source ./judger/scripts/utils/dir.sh

### Locator
#### Find problem id and file extension
source ./judger/scripts/locator.sh

einfo "Finish importing."
## ---

function pre_judge() {
  ## Search for submission files
  einfo "Getting submission files..."
  load_changed_files
  load_submission_from_changed_files

  einfo "Found these files to be judged:"
  cat_tmp_data_file
}

JUDGE_STATUS_EXITCODE=0
JUDGE_FAIL_TESTDATA_ID=""
function judge() {
  einfo "Judging submission $CURR_SUB_FILE for problem $CURR_PROBLEM_ID"

  JUDGE_STATUS_EXITCODE=0
  JUDGE_FAIL_TESTDATA_ID=""

  # Loop over testdata/*_input.itxt
  local testdata_input_files=$(find $CURR_PROBLEM_ID/testdata -name "*_input.txt")
  # Sort testdata input files by name
  testdata_input_files=$(echo "$testdata_input_files" | sort)

  while IFS= read -r input_file; do
    local output_file="${input_file%_input.txt}_output.txt"
    local testdata_id="${input_file##*/}"
    testdata_id="${testdata_id%_input.txt}"

    einfo "[JUDGE] Start judging testdata $testdata_id"
    edebug "Input file: $input_file"
    edebug "Output file: $output_file"

    execute $input_file $output_file
    JUDGE_STATUS_EXITCODE=$?
    if [ $JUDGE_STATUS_EXITCODE -ne 0 ]; then
      JUDGE_FAIL_TESTDATA_ID=$testdata_id
      return 1
    fi

    edebug "[JUDGE] Finish judging testdata $testdata_id"
  done <<< "$testdata_input_files"
  return 0
}

CURR_SUB_FILE=""
function judge_all_files() {
  while IFS= read -r line; do
    # set -e
    CURR_SUB_FILE="$line"

    CURR_SUB_FILE_EXT="${line##*.}"
    set_executor_based_on_file_ext $CURR_SUB_FILE_EXT

    CURR_PROBLEM_ID="${line%%/*}"
    set_grader_based_on_problem_id $CURR_PROBLEM_ID

    ## Set up
    spin_up
    build $CURR_SUB_FILE

    # set +e
    judge
    # set -e

    tear_down
    # set +e
  done < $TMP_DATA_FILE

  einfo "Finish judging all files."

  if [ $JUDGE_STATUS_EXITCODE -ne 0 ]; then
    echo "${RED} ----- WRONG_ANSWER: Testdata $JUDGE_FAIL_TESTDATA_ID failed.  -----${NORMAL}" 
    exit $JUDGE_STATUS_EXITCODE
  fi
}

echo "!!! PR Author: $PR_AUTHOR"

pre_judge
judge_all_files