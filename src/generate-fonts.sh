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
woff2_compress /tmp/text-security-$shape.ttf
mv /tmp/text-security-$shape.woff2 /output/
echo "Font file output/text-security-$shape.woff2 generated"

# Compatibility fonts for browsers that don't support cmap subtable 12 (IE, mainly).
/t1utils/t1asm /tmp/$shape-font.txt > /tmp/$shape-font.pfa
mergefonts -cid /tmp/$shape-cidfontinfo /tmp/$shape-cidfont /tmp/$shape-font.pfa
makeotf -f /tmp/$shape-cidfont -omitMacNames \
  -ff /tmp/$shape-features -fi /tmp/$shape-cidfontinfo \
  -mf /tmp/$shape-FontMenuNameDB -r \
  -stubCmap4 \
  -ch /adobe-blank-2/UnicodeAll-UTF32-H

sfntedit \
  -a DSIG=/adobe-blank/DSIG.bin \
  -d VORG,vhea,vmtx /tmp/text-security-$shape.otf

sfntedit -f /tmp/text-security-$shape.otf

rm -f /tmp/text-security-$shape.ttf
otf2ttf /tmp/text-security-$shape.otf
sfntedit -d DSIG /tmp/text-security-$shape.ttf
mv /tmp/text-security-$shape.ttf /output/text-security-$shape-compat.ttf
echo "Font file output/text-security-$shape-compat.ttf generated"
