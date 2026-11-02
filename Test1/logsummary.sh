#!/bin/bash
if [ "$#" -ne  1 ]; then
   echo "Usage: $0 <log_file>" >&2
   exit 1
fi
LOG_FILE="$1"
if [ ! -e "$LOG_FILE" ]; then
   echo "Error: File '$LOG_FILE' does not exist." >&2
   exit 2
fi
if [ ! -s "$LOG_FILE" ]; then
   echo "Error: File '$LOG_FILE' is empty." >&2
   exit 3
fi
LINES=$(wc -l < "$LOG_FILE")
FAILED=$(grep -c "Failed password" "$LOG_FILE")
ACCEPTED=$(grep -c "Accepted password" "$LOG_FILE")
FIRST=$(head -n 1 "$LOG_FILE" | awk '{print $1, $2, $3}')
LAST=$(tail -n 1 "$LOG_FILE" | awk '{print $1, $2, $3}')
echo "File     : $LOG_FILE"
echo "Lines    : $LINES"
echo "Failed   : $FAILED"
echo "Accepted : $ACCEPTED"
echo "First    : $FIRST"
echo "Last     : $LAST"
exit 0
