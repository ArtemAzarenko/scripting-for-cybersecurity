#!/bin/bash

LOG_COUNT=0
TOTAL_LINES=0

while IFS= read -r -d '' logfile; do
    lines=$(wc -l < "$logfile")
    echo "Log: $logfile | Lines: $lines"

   LOG_COUNT=$((LOG_COUNT + 1))
   TOTAL_LINES=$((TOTAL_LINES + lines))
done < <(find exam-data -type f -name "*.log" -print0)

echo "--- ------ ----- ---- -------"
echo "Total logs found     : $LOG_COUNT"
echo "Total cumulative lines: $TOTAL_LINES"
