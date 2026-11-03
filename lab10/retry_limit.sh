#!/bin/bash
TARGET=""
ATTEMPTS=0
MAX_ATTEMPTS=3

while [ ! -f "$TARGET" ] && [ "$ATTEMPTS" -lt "$MAX_ATTEMPTS" ]; do
    read -p "Enter a file inside case/ to identify: " TARGET
    TARGET="case/$TARGET"
    ATTEMPTS=$((ATTEMPTS + 1))
    if [ ! -f "$TARGET" ]; then
        echo "  '$TARGET' is not a regular file ($ATTEMPTS/$MAX_ATTEMPTS attempts used)"
    fi
done

if [ -f "$TARGET" ]; then
    echo "$TARGET: $(file -b "$TARGET")"
else
    echo "Too many failed attempts." >&2
    exit 1
fi

