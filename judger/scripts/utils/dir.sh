#!/bin/bash

## MAY BE DEPRECATED

## Import utils 
source judger/scripts/utils/peccho.sh

## Temporary file to store values
TMP_DATA_FILE="$(pwd)/tmpdata"

SOURCE_TO_CMP="HEAD"
DEST_TO_CMP="origin/main"

# Load a list of name of files being changed between two git source
# Persist results to TMP_DATA_FILE
function load_changed_files {
  einfo "Loading changed files from git diff $SOURCE_TO_CMP to $DEST_TO_CMP"
  local tmp=$(git diff --name-only $SOURCE_TO_CMP $DEST_TO_CMP)

  edebug "Git diff from <$SOURCE_TO_CMP> to <$DEST_TO_CMP>:"
  edebug "-------"
  if [ "$DEBUG" = "true" ]; then
    echo $tmp
  fi
  edebug "-------"
  echo

  # Persist
  echo $tmp | tr ' ' '\n' > $TMP_DATA_FILE
  esucceed "Wrote to $TMP_DATA_FILE."
}

SUBMISSION_REGEX_TO_FILTER=^challenge_[0-9]+\/submit\/main\.+$

# Load submission files from a list of files from TMP_DATA_FILE
# Filter by regex of submission path.
# Then persist results to TMP_DATA_FILE
function load_submission_from_changed_files {
  einfo "Loading submissions from changed files"

  edebug "Check file: $TMP_DATA_FILE"
  cat $TMP_DATA_FILE

  if [ ! -f $TMP_DATA_FILE ]; then
    efatal "Missing tmp data file: $TMP_DATA_FILE"
    efatal "Be sure to run load_changed_files first."
    return 1
  fi

  local tmp=()
  while IFS=" " read -r line; do
    edebug "Check line: $line"
    if [[ $line =~ $SUBMISSION_REGEX_TO_FILTER ]]; then
      tmp+=( $line )
    fi
  done < $TMP_DATA_FILE

  edebug "Found submissions:"
  edebug "-------"
  if [ "$DEBUG" = "true" ]; then
    echo $tmp
  fi
  edebug "-------"
  echo

  # Persist
  echo $tmp > $TMP_DATA_FILE
  esucceed "Updated $TMP_DATA_FILE."
}

function cat_tmp_data_file {
  if [ ! -f $TMP_DATA_FILE ]; then
    efatal "Missing tmp data file: $TMP_DATA_FILE"
    efatal "Be sure to run load_changed_files first."
    return 1
  fi

  cat $TMP_DATA_FILE
}
