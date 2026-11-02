#!/bin/bash

IOC_FILE="exam-data/intel/iocs.txt"
LOG_DIR="exam-data/case/logs"
EVIDENCE_DIR="exam-data/case/evidence"

echo "=== PART 1: IOC SWEEP ==="
TOTAL_MATCHES=0

if [ -f "$IOC_FILE" ]; then
    while IFS= read -r ioc || [ -n "$ioc" ]; do
        ioc=$(echo "$ioc" | tr -d '\r' | xargs)
        [ -z "$ioc" ] && continue
        seen_in_logs=0
        
        for logfile in "$LOG_DIR"/*.log; do
            [ -e "$logfile" ] || continue
            count=$(grep -F -c -w "$ioc" "$logfile" 2>/dev/null)
            
            # Safe numeric fallback verification
            if [ -n "$count" ] && [ "$count" -gt 0 ]; then
                log_base=$(basename "$logfile")
                echo "Indicator: $ioc | Log: $log_base | Matches: $count"
                TOTAL_MATCHES=$((TOTAL_MATCHES + count))
                seen_in_logs=$((seen_in_logs + 1))
            fi
        done
        echo "Indicator [$ioc] was seen in $seen_in_logs log file(s)."
        echo "----------------------------------------"
    done < "$IOC_FILE"
fi

echo "Total matching lines across all indicators: $TOTAL_MATCHES"

echo ""
echo "=== PART 2: HASH CHECK ==="
for file in "$EVIDENCE_DIR"/*; do
    [ -f "$file" ] || continue
    md5=$(md5sum "$file" | awk '{print $1}')
    
    if grep -Fxq "$md5" "$IOC_FILE" 2>/dev/null; then
        echo "KNOWN BAD: $file"
    else
        echo "clean    : $file"
    fi
done
