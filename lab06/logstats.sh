#!/bin/bash
# logstats.sh - print basic statistics for a log file
# Usage: ./logstats.sh <logfile>

if [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

LOGFILE=$1

if [ ! -f "$LOGFILE" ]; then
    echo "Error: file '$LOGFILE' not found" >&2
    exit 2
fi

LINE_COUNT=$(wc -l < "$LOGFILE")
WORD_COUNT=$(wc -w < "$LOGFILE")
CHAR_COUNT=$(wc -c < "$LOGFILE")
FIRST_LINE=$(head -n 1 "$LOGFILE")
LAST_LINE=$(tail -n 1 "$LOGFILE")
LONGEST_LINE=$(awk '{ print length }' "$LOGFILE" | sort -rn | head -n 1)
FAILED=$(grep -c "Failed password" "$LOGFILE")

echo "Log file        : $LOGFILE"
echo "Total lines     : $LINE_COUNT"
echo "Total words     : $WORD_COUNT"
echo "Total characters: $CHAR_COUNT"
echo "First line      : $FIRST_LINE"
echo "Last line       : $LAST_LINE"
echo "Longest line    : $LONGEST_LINE characters"
echo "Failed logins   : $FAILED"

read -p "Enter a keyword to search for (or press Enter to skip): " KEYWORD

if [ -n "$KEYWORD" ]; then
    MATCH_COUNT=$(grep -c "$KEYWORD" "$LOGFILE")
    # Echo exit code of grep -c as requested in Exercise 5.3
    # Note: grep -c exits 0 even if count is 0, as long as it scanned fine.
    # Exits 1 only if pattern matches 0 lines when NOT using count, or if specific parameters hit.
    # Let's cleanly show match results based on Exercise 5.4 requirements:
    if [ "$MATCH_COUNT" -eq 0 ]; then
        echo "No matches found."
    else
        echo "Lines containing '$KEYWORD': $MATCH_COUNT"
    fi
fi
exit 0
