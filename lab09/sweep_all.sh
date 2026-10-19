#!/bin/bash
for LOGFILE in case/logs/*.log; do
    echo "=== $LOGFILE ==="
    for INDICATOR in $(cat intel/iocs.txt); do
        if grep -qwF "$INDICATOR" "$LOGFILE"; then
            echo "  MATCH: $INDICATOR ($(grep -cwF "$INDICATOR" "$LOGFILE") lines)"
        fi
    done
done
