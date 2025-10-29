#!/bin/bash

set -e
trap 'echo "error in line no:$LINENO,cmd failed: $BASH_COMMAND"' ERR

echo "hello"
echo "before error"
s;aslas  # singl ERR
echo "after error"