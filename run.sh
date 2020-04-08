#!/bin/sh
mkdir -p dist

docker run \
  --mount type=bind,source="$(pwd)"/src,destination=/src \
  --mount type=bind,source="$(pwd)"/dist,destination=/dist \
  f2110d2c28fc python /src/generate-fonts.py