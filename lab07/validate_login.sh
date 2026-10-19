#!/bin/bash
read -p "Enter username: " USERNAME

if [ -z "$USERNAME" ]; then
    echo "Error: username cannot be empty" >&2
    exit 1
fi

LOG="case/logs/auth.log"
USER_CSV="intel/users.csv"
USER_OLD="case/backups/users.old"
PASS_TXT="case/evidence/passwords.txt"

if grep -q "^$USERNAME," "$USER_CSV"; then
    SRC_TYPE="CURRENT"
    ROLE=$(grep "^$USERNAME," "$USER_CSV" | cut -d',' -f3)
    STATUS=$(grep "^$USERNAME," "$USER_CSV" | cut -d',' -f4 | tr -d '\r')
    echo "$USERNAME: CURRENT account (Role: $ROLE, Status: $STATUS)"
    EXIT_VAL=0
elif grep -qx "$USERNAME" "$USER_OLD"; then
    SRC_TYPE="LEGACY"
    echo "$USERNAME: LEGACY account (only in historical backup files)"
    EXIT_VAL=2
else
    SRC_TYPE="UNKNOWN"
    echo "$USERNAME: UNKNOWN account (unrecognized)"
    EXIT_VAL=3
fi

FAIL_COUNT=0
OK_COUNT=0
[ -f "$LOG" ] && FAIL_COUNT=$(grep -c "Failed password for $USERNAME " "$LOG")
[ -f "$LOG" ] && OK_COUNT=$(grep -c "Accepted password for $USERNAME " "$LOG")

echo "Attempts metrics -> Failed: $FAIL_COUNT | Accepted: $OK_COUNT"

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "Risk classification: NONE"
elif [ "$FAIL_COUNT" -lt 5 ]; then
    echo "Risk classification: LOW"
elif [ "$FAIL_COUNT" -lt 15 ]; then
    echo "Risk classification: MEDIUM"
else
    echo "Risk classification: HIGH"
fi

if [ "$SRC_TYPE" = "CURRENT" ] && [ "$STATUS" = "disabled" ] && [ "$OK_COUNT" -gt 0 ]; then
    echo "WARNING: Disabled active account has accepted authentication instances!"
fi

if { [ "$SRC_TYPE" = "LEGACY" ] || [ "$SRC_TYPE" = "UNKNOWN" ]; } && [ "$FAIL_COUNT" -gt 0 ]; then
    echo "WARNING: Bruteforce signature targeted to invalid non-existent account names"
fi

if [ "$SRC_TYPE" = "CURRENT" ] && [ "$OK_COUNT" -gt 0 ] && grep -q "^$USERNAME:" "$PASS_TXT"; then
    echo "WARNING: Leaked plaintext credentials matched inside passwords dump document!"
fi

exit $EXIT_VAL
