#!/bin/bash

docker run -d -p 2222:22 --name $(cat ctf/image-name) $(cat ctf/image-tag)
