#!/bin/sh
mkdir -p bin

docker run \
  --mount type=bind,source="$(pwd)"/src,destination=/src \
  --mount type=bind,source="$(pwd)"/output,destination=/output \
  text-security-font-builder python /src/generate-fonts.py