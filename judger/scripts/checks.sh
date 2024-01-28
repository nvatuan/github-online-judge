#!/bin/bash

## Check if yq is installed
if ! command -v yq &> /dev/null
then
  echo "yq could not be found. Please install yq first."
  exit 1
fi

## Check if docker daemon is running
if ! docker info &> /dev/null
then
  echo "Docker daemon is not running. Please start docker daemon first."
  exit 1
fi

echo "OK"