#!/bin/bash
if [ $# -eq 0 ]; then
    echo "Error: no filename supplied" >&2
    exit 1
fi
if [ ! -f "$1" ]; then
    echo "Error: '$1' does not exist" >&2
    exit 2
fi
if [ ! -r "$1" ]; then
    echo "Error: '$1' exists but cannot be read" >&2
    exit 3
fi
if [ ! -s "$1" ]; then
    echo "Error: '$1' is empty" >&2
    exit 4
fi
echo "'$1' looks fine — $(wc -l < "$1") lines"
exit 0
