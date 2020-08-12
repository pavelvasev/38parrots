#!/bin/bash

Q=$(dirname "$(readlink -f "$0")")

$Q/../codemusic.viewlang/compile.sh
