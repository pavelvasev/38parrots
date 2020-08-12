#!/bin/bash -e

Q=$(dirname "$(readlink -f "$0")")

cd $Q

cm-viewlang <input.cm >result.vl 2>log.txt || echo ERROR

echo OK
