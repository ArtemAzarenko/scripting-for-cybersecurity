#!/bin/bash

if [ "$#" -ne 1 ] || [[ ! "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Please provide exactly one valid IPv4 address." >&2
    exit 1
fi

IP="$1"
AUTH_LOG="exam-data/case/logs/auth.log"
FW_LOG="exam-data/case/logs/firewall.log"
IOC_FILE="exam-data/intel/iocs.txt"

FAILED=$(grep "Failed password" "$AUTH_LOG" | grep -c -w "$IP")
ACCEPTED=$(grep "Accepted password" "$AUTH_LOG" | grep -c -w "$IP")

if [ "$FAILED" -eq 0 ]; then
   RISK="NONE"
elif [ "$FAILED" -le 4 ]; then
   RISK="LOW"
elif [ "$FAILED" -le 9 ]; then
   RISK="MEDIUM"
else
   RISK="HIGH"
fi

echo "Failed   : $FAILED ($RISK)"
echo "Accepted : $ACCEPTED"

if grep -Fxq "$IP" "$IOC_FILE" 2>/dev/null; then
    echo "IOC      : yes"
else
    echo "IOC      : no"
fi

if [ -f "$FW_LOG" ] && grep -q -w "$IP" "$FW_LOG"; then
    echo "Firewall entries:"
    grep -w "$IP" "$FW_LOG"
else
    echo "Firewall : no entries"
fi

if [ "$FAILED" -gt 0 ] && [ "$ACCEPTED" -gt 0 ]; then
    echo "WARNING: successful login after failed attempts"
fi

if grep -qs -w "$IP" exam-data/case/logs/*; then
    exit 0
else
    exit 3
fi
