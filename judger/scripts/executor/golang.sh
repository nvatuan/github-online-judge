#!/bin/bash

## Import pretty echo
source ./judger/scripts/utils/peccho.sh

DOCKER_IMAGE="golang:1.17"
DOCKER_WORKING_DIR="$(pwd)/tmpworkdir"

CONTAINER_WORKDIR="/usr/saibansho"
CONTAINER_NAME="konteinaa"

SUBMISSION_NAME="main.go"
OUT_BINARY_NAME="bin"

function spin_up {
  einfo "Spinning up environments.." 

  edebug "| Pulling image for exec environment.."
  docker pull $DOCKER_IMAGE

  edebug "| Making share volume"
  mkdir -p $DOCKER_WORKING_DIR

  edebug "| Running docker in the background"

  docker run --rm --name $CONTAINER_NAME \
    -t -d \
    -v $DOCKER_WORKING_DIR:$CONTAINER_WORKDIR \
    -w $CONTAINER_WORKDIR \
    $DOCKER_IMAGE

  einfo "Finish spinning up environments"
  echo
}

# @params: $1 -> file path and name (name should always be main.go)
function build {
  einfo "Building Go program"

  if [ -z $1 ]; then
    efatal "Missing argument. Usage: build <go file path and name>"
    return 1
  fi

  if [ ! -f $1 ]; then
    efatal "File not found: $1"
    return 1
  fi

  edebug "| Copying submission file to container"
  cp $1 $DOCKER_WORKING_DIR

  edebug "| Running go build"
  docker exec -t \
    $CONTAINER_NAME \
    go build -o "$CONTAINER_WORKDIR/$OUT_BINARY_NAME" $SUBMISSION_NAME

  if [ $? -ne 0 ]; then
    efail "| Build failed"
    return 1
  fi

  # If debug set, list files in container
  if [ ! -z $DEBUG ]; then
    edebug "| Listing files in container"
    docker exec -t \
      $CONTAINER_NAME \
      ls -la
  fi

  einfo "Build finish"
}

# @params: $1 -> test data input file
# @params: $2 -> test data output file
function execute {
  edebug "Executing Go program"

  if [ -z $1 ] || [ -z $2 ]; then
    efatal "Missing argument. Usage: execute <input file> <output file>"
    return 1
  fi

  if [ ! -f $1 ] ; then
    efatal "File not found: $1"
    return 1
  fi

  if [ ! -f $2 ] ; then
    efatal "File not found: $2"
    return 1
  fi

  local exec_output_file="sub_output.txt"
  local participant_output_path="$DOCKER_WORKING_DIR/$exec_output_file"

  edebug "| Executing program:"
  edebug "| | Input file path: $1"
  edebug "| | Participant output file path: $participant_output_path"

  cat $1 | docker exec -i $CONTAINER_NAME "./$OUT_BINARY_NAME" > $participant_output_path

  edebug "| Execute grader:"
  do_grading $2 $participant_output_path # From grader/<grader_name>.sh
  if [ $? -ne 0 ]; then
    return 1
  fi
  return 0
}

function tear_down {
  einfo "Tearing down"
  edebug "| Stopping container: $(docker stop $CONTAINER_NAME)"

  edebug "| Removing working directory: $DOCKER_WORKING_DIR"
  rm -rf $DOCKER_WORKING_DIR

  einfo "Tearing down finished."
}