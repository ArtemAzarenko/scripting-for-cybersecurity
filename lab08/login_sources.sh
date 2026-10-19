#!/bin/bash
USERNAME=$1
LOG="case/logs/auth.log"

SOURCES=$(grep "Accepted password for $USERNAME " "$LOG" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort -u)

if [ -z "$SOURCES" ]; then
    echo "$USERNAME: no successful logins"
else
    COUNT=$(echo "$SOURCES" | wc -l)
    echo "$USERNAME logged in from $COUNT different address(es):"
    echo "$SOURCES"
fi
