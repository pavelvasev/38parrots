#!/bin/bash -e

Q=$(dirname "$(readlink -f "$0")")

cd $Q

cat *.cm | PARROTS_DIR=$Q TARGET_DIR=$Q/.. cm-viewlang  >../result.vl 2>log.txt || (echo ERROR; exit 1)

echo OK