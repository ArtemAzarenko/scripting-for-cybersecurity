#!/bin/bash
LOG="case/logs/firewall.log"
FOUND=""

while IFS= read -r INDICATOR || [ -n "$INDICATOR" ]; do
    if grep -qwF "$INDICATOR" "$LOG"; then
        echo "First match in $LOG: $INDICATOR — stopping search."
        FOUND="yes"
        break
    fi
done < intel/iocs.txt

if [ -z "$FOUND" ]; then
    echo "No indicators matched within $LOG."
fi
