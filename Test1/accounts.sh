#!/bin/bash

USER_CSV="exam-data/intel/users.csv"
AUTH_LOG="exam-data/case/logs/auth.log"

ACTIVE_COUNT=0
DISABLED_COUNT=0
HEADER_SKIPPED=false

if [ ! -f "$USER_CSV" ]; then
    echo "Error: Accounts file missing." >&2
    exit 1
fi

while IFS=',' read -r username role status department || [ -n "$username" ]; do
    if [ "$HEADER_SKIPPED" = false ]; then
        HEADER_SKIPPED=true
        continue
    fi
    
    # Strip hidden carriage returns (\r) to clean up department strings
    username=$(echo "$username" | tr -d '\r' | xargs)
    role=$(echo "$role" | tr -d '\r' | xargs)
    status=$(echo "$status" | tr -d '\r' | xargs)
    department=$(echo "$department" | tr -d '\r' | xargs)
    
    [ -z "$username" ] && continue

    logins=$(grep "Accepted password" "$AUTH_LOG" | grep -c -w "$username")
    
    echo "$username | $role | $status | $department | logins: $logins"
    
    if [ "$status" = "disabled" ] && [ "$logins" -gt 0 ]; then
        echo "ALERT: Disabled account '$username' has $logins successful log-in entries!"
    fi
    
    if [ "$status" = "active" ]; then
        ((ACTIVE_COUNT++))
    elif [ "$status" = "disabled" ]; then
        ((DISABLED_COUNT++))
    fi
done < "$USER_CSV"

echo "----------------------------------------"
echo "Total Active Accounts  : $ACTIVE_COUNT"
echo "Total Disabled Accounts: $DISABLED_COUNT"
