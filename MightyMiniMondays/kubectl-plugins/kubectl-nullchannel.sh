#!/bin/bash

# optional argument handling
if [[ "$1" == "version" ]]
then
    echo "0.0.1"
    exit 0
fi

# optional argument handling
if [[ "$1" == "name" ]]
then
  echo "nullchannel kubectl plugin"
  exit 0
fi

if [[ "$1" == "help" ]]
then
  echo "I do nothing"
  exit 0
fi

# default
echo "Use help for usage."
