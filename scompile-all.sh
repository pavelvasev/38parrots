#!/bin/bash -e

Q=$(dirname "$(readlink -f "$0")")

cd $Q

echo "==================== main"
src/scompile.sh
echo "==================== views"
views/scompile.sh

echo all compiled ok
