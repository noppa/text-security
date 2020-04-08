#!/usr/bin/env bash
set -e
mkdir -p build-artifacts

sed -e '/<<SHAPE>>/ r shapes/circle.ps' -e 's/<<SHAPE>>//' font-template.ps > build-artifacts/circle.txt

t1utils/t1asm build-artifacts/circle.txt > ./font.pfa
mergefonts -cid cidfontinfo cidfont.ps font.pfa
makeotf -f cidfont.ps -omitMacNames -ff features -fi cidfontinfo -mf FontMenuNameDB -r -ch UnicodeAll-UTF32-H

sfntedit -a DSIG=DSIG.bin,OS/2=OS2.bin,cmap=cmap.bin -d VORG,vhea,vmtx text-security.otf
sfntedit -f text-security.otf

rm -f text-security.ttf
otf2ttf text-security.otf
sfntedit -d DSIG text-security.ttf