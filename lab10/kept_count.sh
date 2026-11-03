# kept_count.sh
#!/bin/bash
COUNT=0
TOTAL_LINES=0
while IFS= read -r -d '' LOGFILE; do
    COUNT=$((COUNT + 1))
    LINES=$(wc -l < "$LOGFILE")
    TOTAL_LINES=$((TOTAL_LINES + LINES))
done < <(find case -type f -name "*.log" -print0)
echo "after the loop: COUNT=$COUNT"
echo "total lines across all logs: $TOTAL_LINES"
