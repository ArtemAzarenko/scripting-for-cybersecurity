#!/bin/bash
TARGET=$1
if [ -f "$TARGET" ] || [ -d "$TARGET" ]; then
    echo "$TARGET is a file or a directory."
else
    echo "$TARGET is neither (or does not exist)."
fi
