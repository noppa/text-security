#!/usr/bin/env bash

set -e

../t1utils/t1asm ./font.txt > ./font.pfa
source ../afdko_env/bin/activate
mergefonts -cid cidfontinfo cidfont.ps font.pfa
makeotf -f cidfont.ps -omitMacNames -ff features -fi cidfontinfo -mf FontMenuNameDB -r -ch UnicodeAll-UTF32-H

sfntedit -a DSIG=DSIG.bin,OS/2=OS2.bin,cmap=cmap.bin -d VORG,vhea,vmtx AdobeBlank2.otf
sfntedit -f AdobeBlank2.otf

rm -f AdobeBlank2.ttf
otf2ttf AdobeBlank2.otf
sfntedit -d DSIG AdobeBlank2.ttf

http-server .