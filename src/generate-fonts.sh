#!/bin/sh

set -e
/t1utils/t1asm /build-artifacts/font-circle.txt > /build-artifacts/font.pfa
mergefonts -cid /src/cidfontinfo /build-artifacts/cidfont.ps /build-artifacts/font.pfa
makeotf -f /build-artifacts/cidfont.ps -omitMacNames \
  -ff /src/features -fi /src/cidfontinfo \
  -mf /src/FontMenuNameDB -r \
  -ch /adobe-blank-2/UnicodeAll-UTF32-H

sfntedit \
  -a DSIG=/adobe-blank-2/DSIG.bin,OS/2=/adobe-blank-2/OS2.bin,cmap=/adobe-blank-2/cmap.bin \
  -d VORG,vhea,vmtx /build-artifacts/text-security.otf

sfntedit -f /build-artifacts/text-security.otf

rm -f /build-artifacts/text-security.ttf
otf2ttf /build-artifacts/text-security.otf
sfntedit -d DSIG /build-artifacts/text-security.ttf
mv /build-artifacts/text-security.ttf /output/