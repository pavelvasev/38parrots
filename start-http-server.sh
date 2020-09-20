#!/bin/bash

############ setup
# 1. install nodejs from
#    https://nodejs.org/en/download/package-manager/
# 2. then run :
#    npm install -g http-server

echo "* * * * After server started, navigate to file run.html * * * *"

Q=$(dirname "$(readlink -f "$0")")
http-server "$Q" --cors
