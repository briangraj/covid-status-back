#!/bin/bash

docker build -t csb:latest .

# docker tag <existing-image> <hub-user>/<repo-name>[:<tag>]
docker tag csb:latest briangraj/csb:latest

# docker push <hub-user>/<repo-name>:<tag>
docker push briangraj/csb:latest
