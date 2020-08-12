#!/bin/bash -e

Q=$(dirname "$(readlink -f "$0")")

cd $Q

for x in **/scompile.sh; do
  echo "================== $x"
  "$x"
done

echo views compiled ok