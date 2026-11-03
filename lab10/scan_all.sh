#!/bin/bash
TOTAL_MATCHES=0

while IFS= read -r -d '' LOGFILE; do
    LINE_COUNT=$(wc -l < "$LOGFILE")
    FAILED_LOGINS=$(grep -c "Failed password" "$LOGFILE" 2>/dev/null || echo 0)
    FILE_MATCHES=0
    
    while IFS= read -r INDICATOR || [ -n "$INDICATOR" ]; do
        [ -z "$INDICATOR" ] && continue
        if grep -qwF "$INDICATOR" "$LOGFILE"; then
            FILE_MATCHES=$((FILE_MATCHES + 1))
            TOTAL_MATCHES=$((TOTAL_MATCHES + 1))
            
            if [ "$FILE_MATCHES" -eq 3 ]; then
                echo "[$LOGFILE] Check stopped early: 3 indicators hit."
                break
            fi
        fi
    done < intel/iocs.txt
    
    echo "File: $LOGFILE | Lines: $LINE_COUNT | Failed Logins: $FAILED_LOGINS | IOC Matches: $FILE_MATCHES"
    echo "--------------------------------------------------------"
done < <(find case -type f -name "*.log" -print0)

echo "Total IOC matches across collection: $TOTAL_MATCHES"

if [ "$TOTAL_MATCHES" -gt 0 ]; then
    exit 1
else
    exit 0
fi
