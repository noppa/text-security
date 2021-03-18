#!/bin/sh

mkdir -p output

podman run \
  -v "$(pwd)/src":/src:z \
  -v "$(pwd)/output":/output:z \
  text-security-font-builder python /src/generate-fonts.py $1
