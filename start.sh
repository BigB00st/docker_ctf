#!/bin/bash

docker run -d -p 2222:22 --name $(cat image-name) $(cat image-tag)
