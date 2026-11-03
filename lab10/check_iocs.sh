#!/bin/bash
IOC_FILE="intel/iocs.txt"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

LOGFILE=$1
if [ ! -f "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' not found" >&2
    exit 2
fi

MATCHES=0
MISSES=0

while IFS= read -r INDICATOR || [ -n "$INDICATOR" ]; do
    [ -z "$INDICATOR" ] && continue
    if grep -qwF "$INDICATOR" "$LOGFILE"; then
        echo "MATCH: $INDICATOR"
        MATCHES=$((MATCHES + 1))
    else
        MISSES=$((MISSES + 1))
    fi
done < "$IOC_FILE"

echo "Total IOC matches in $LOGFILE: $MATCHES"
echo "Total IOC misses in $LOGFILE: $MISSES"
