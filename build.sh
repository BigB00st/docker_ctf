#!/bin/bash

if [ -z "$1" ]
  then
    echo "Specify the binary to pass to the container"
    exit 1
fi

docker build --build-arg binary=$1 --build-arg user=$(cat ctf/user) -t $(cat ctf/image-tag) .
