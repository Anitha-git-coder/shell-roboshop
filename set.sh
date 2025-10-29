#!/bin/bash

set -e
error()
{
    echo "error in line no:$LINENO,cmd failed: $BASH_COMMAND"
}

trap 'error' ERR

echo "hello"
echo "before error"
s;aslas  # singl ERR
echo "after error"