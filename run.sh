#!/bin/sh
mkdir -p bin

docker run \
  --mount type=bind,source="$(pwd)"/src,destination=/src \
  --mount type=bind,source="$(pwd)"/output,destination=/output \
  f2110d2c28fc python /src/generate-fonts.py