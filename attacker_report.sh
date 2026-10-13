#!/bin/bash
# attacker_report.sh - Script for tracking active network attackers

if [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

LOGFILE=$1

if [ ! -f "$LOGFILE" ]; then
    echo "Error: file '$LOGFILE' not found" >&2
    exit 2
fi

# 1. Total Failed Password Events
FAILED_COUNT=$(grep -c "Failed password" "$LOGFILE" 2>/dev/null)
echo "Total Failed Password Events: $FAILED_COUNT"

if [ "$FAILED_COUNT" -eq 0 ]; then
    echo "Top Attacker IP: None"
    echo "Top 3 Attacker IPs:"
    echo "None"
    echo "Top 3 Targeted Usernames:"
    echo "None"
    exit 0
fi

# 2. Single Top IP Address
TOP_IP=$(grep "Failed password" "$LOGFILE" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
echo "Top Attacker IP: $TOP_IP"

# 3. Top 3 Attacker IPs
echo "Top 3 Attacker IPs:"
grep "Failed password" "$LOGFILE" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr | head -n 3

# 4. Top 3 Targeted Usernames
echo "Top 3 Targeted Usernames:"
grep "Failed password" "$LOGFILE" | awk '{for(i=1;i<=NF;i++) if($i=="invalid") {print $(i+1)} else {for(j=1;j<=NF;j++) if($j=="for") print $(j+1)}}' | sort | uniq -c | sort -nr | head -n 3

exit 0
