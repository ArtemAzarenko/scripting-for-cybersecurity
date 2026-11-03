#!/bin/bash
FIRST_LINE=1

while IFS=',' read -r USERNAME ROLE STATUS DEPT || [ -n "$DEPT" ]; do
    if [ "$FIRST_LINE" -eq 1 ]; then
        FIRST_LINE=0
        continue
    fi
    DEPT=${DEPT%$'\r'}
    
    if [ "$STATUS" = "disabled" ]; then
        echo "User: $USERNAME | role: $ROLE | status: $STATUS | dept: [$DEPT]"
    fi
done < intel/users.csv
