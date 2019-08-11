#!/usr/bin/env bash

set -o nounset
set -o errexit

docker build -t "${DOCKER_IMAGE:-ursim}" .
