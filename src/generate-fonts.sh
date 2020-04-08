#!/bin/sh
set -e

shape=$1

/t1utils/t1asm /tmp/$shape-font.txt > /tmp/$shape-font.pfa
mergefonts -cid /tmp/$shape-cidfontinfo /tmp/$shape-cidfont /tmp/$shape-font.pfa
makeotf -f /tmp/$shape-cidfont -omitMacNames \
  -ff /tmp/$shape-features -fi /tmp/$shape-cidfontinfo \
  -mf /tmp/$shape-FontMenuNameDB -r \
  -ch /adobe-blank-2/UnicodeAll-UTF32-H

sfntedit \
  -a DSIG=/adobe-blank-2/DSIG.bin,OS/2=/adobe-blank-2/OS2.bin,cmap=/adobe-blank-2/cmap.bin \
  -d VORG,vhea,vmtx /tmp/text-security-$shape.otf

sfntedit -f /tmp/text-security-$shape.otf

rm -f /tmp/text-security-$shape.ttf
otf2ttf /tmp/text-security-$shape.otf
sfntedit -d DSIG /tmp/text-security-$shape.ttf
mv /tmp/text-security-$shape.ttf /output/