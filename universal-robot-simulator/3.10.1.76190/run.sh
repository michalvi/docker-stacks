#!/usr/bin/env bash

set -o nounset
set -o errexit

nvidia-docker run -id \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --env DISPLAY \
    --net host \
    --name ursim \
  "${DOCKER_IMAGE:-ursim}" "$@"
