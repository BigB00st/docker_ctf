#!/bin/bash

name=$(cat image-name)
docker stop $name
docker rm $name
# decomment to remove image
# docker image rm $name
