#!/bin/bash

#!/bin/bash
set -e

# Track the last executed command and its line number
trap 'last_command=$current_command; current_command=$BASH_COMMAND; last_lineno=$LINENO' DEBUG

# Report error using the last tracked command and line number
trap 'echo "Error on line $last_lineno: $last_command"' ERR

echo "hello"
echo "before error"
s;aslas  # This will trigger the trap
echo "after error"  # Won't run due to set -e
