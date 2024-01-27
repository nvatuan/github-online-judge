#!/bin/bash

## Check if yq is installed
if ! command -v yq &> /dev/null
then
  echo "yq could not be found. Please install yq first."
  exit 1
fi

echo "OK"