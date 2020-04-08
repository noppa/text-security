#!/bin/sh

set -e
t1utils/t1asm /build-artifacts/font-circle.txt > /build-artifacts/font.pfa
mergefonts -cid cidfontinfo cidfont.ps /build-artifacts/font.pfa
makeotf -f cidfont.ps -omitMacNames -ff features -fi cidfontinfo -mf FontMenuNameDB -r -ch UnicodeAll-UTF32-H

sfntedit -a DSIG=DSIG.bin,OS/2=OS2.bin,cmap=cmap.bin -d VORG,vhea,vmtx text-security.otf
sfntedit -f text-security.otf

rm -f text-security.ttf
otf2ttf text-security.otf
sfntedit -d DSIG text-security.ttf