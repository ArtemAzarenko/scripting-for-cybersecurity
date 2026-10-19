#!/bin/bash
TARGET_DIRS=("case/evidence" "case/scripts" "case/logs")
IOC_FILE="intel/iocs.txt"

TOTAL_SURVEYED=0
TOTAL_FLAGGED=0
TOTAL_IOC_MATCHES=0

echo "=== WORKSTATION FORENSIC SURVEY REPORT ==="

for DIR in "${TARGET_DIRS[@]}"; do
    if [ ! -d "$DIR" ]; then continue; fi
    for FILE in "$DIR"/*; do
        [ -f "$FILE" ] || continue
        TOTAL_SURVEYED=$((TOTAL_SURVEYED + 1))
        
        BYTES_SIZE=$(wc -c < "$FILE")
        DETECTED_TYPE=$(file -b "$FILE")
        SHA_HASH=$(sha256sum "$FILE" | awk '{print $1}')
        
        echo "--------------------------------------------------------"
        echo "File: $FILE"
        echo "Size: $BYTES_SIZE bytes"
        echo "Hash: $SHA_HASH"
        
        if [[ "$DETECTED_TYPE" == *text* || "$FILE" == *.log ]]; then
            echo "Line Count: $(wc -l < "$FILE") lines"
        fi
        
        MISMATCH=0
        if [[ "$FILE" == *.png && "$DETECTED_TYPE" != *PNG* && "$DETECTED_TYPE" != *text* ]]; then MISMATCH=1
        elif [[ "$FILE" == *.zip && "$DETECTED_TYPE" != *Zip* && "$DETECTED_TYPE" != *text* ]]; then MISMATCH=1
        elif [[ "$FILE" == *.sh && "$DETECTED_TYPE" != *shell* ]]; then MISMATCH=1
        elif [[ "$FILE" == *.py && "$DETECTED_TYPE" != *Python* ]]; then MISMATCH=1; fi
        
        if [ "$MISMATCH" -eq 1 ]; then
            echo "!! DETECTED EXTENSION MISMATCH ANOMALY"
            TOTAL_FLAGGED=$((TOTAL_FLAGGED + 1))
        fi
        
        if [[ "$FILE" == *.log ]] && [ -f "$IOC_FILE" ]; then
            MATCH_IOC_COUNT=0
            for IOC in $(cat "$IOC_FILE"); do
                if grep -qwF "$IOC" "$FILE"; then
                    MATCH_IOC_COUNT=$((MATCH_IOC_COUNT + 1))
                fi
            done
            echo "Threat Profile: Matches $MATCH_IOC_COUNT threat indicators"
            TOTAL_IOC_MATCHES=$((TOTAL_IOC_MATCHES + MATCH_IOC_COUNT))
        fi
    done
done

echo "========================================================"
echo "===             FINAL RUNTIME SUMMARY METRICS        ==="
echo "========================================================"
echo "Total files surveyed           : $TOTAL_SURVEYED"
echo "Total extension mismatches (!!) : $TOTAL_FLAGGED"
echo "Total global IOC matches found : $TOTAL_IOC_MATCHES"
