#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Usage: $0 <logfile> <search_term>" >&2
    exit 1
fi

LOGFILE_ARG=$1
TERM_ARG=$2

if [ ! -e "$LOGFILE_ARG" ]; then echo "Error: Path does not exist." >&2; exit 10; fi
if [ ! -f "$LOGFILE_ARG" ]; then echo "Error: Target path is not a file." >&2; exit 11; fi
if [ ! -r "$LOGFILE_ARG" ]; then echo "Error: Read execution permission denied." >&2; exit 12; fi

if [ -z "$TERM_ARG" ]; then
    echo "Error: Search argument cannot be blank." >&2
    exit 13
fi

FIREWALL_LOG="case/logs/firewall.log"
IOC_FILE="intel/iocs.txt"
USER_CSV="intel/users.csv"
USER_OLD="case/backups/users.old"

if echo "$TERM_ARG" | grep -Eq '^[0-9]+(\.[0-9]+){3}$'; then
    echo "Processing Mode: NETWORK TARGET ENTRY CHECK [IP: $TERM_ARG]"
    TOTAL_OCCURRENCES=$(grep -cwF "$TERM_ARG" "$LOGFILE_ARG")
    FAILED_ATTEMPTS=$(grep -wF "$TERM_ARG" "$LOGFILE_ARG" | grep -c "Failed password")
    
    echo "Total lines found in $LOGFILE_ARG: $TOTAL_OCCURRENCES"
    echo "Bruteforce password events: $FAILED_ATTEMPTS"
    
    if [ "$FAILED_ATTEMPTS" -eq 0 ]; then echo "Risk Classification: NONE"
    elif [ "$FAILED_ATTEMPTS" -lt 5 ]; then echo "Risk Classification: LOW"
    elif [ "$FAILED_ATTEMPTS" -lt 15 ]; then echo "Risk Classification: MEDIUM"
    else echo "Risk Classification: HIGH"; fi
    
    if [ -f "$FIREWALL_LOG" ] && grep -qwF "$TERM_ARG" "$FIREWALL_LOG"; then
        echo ">>> Matching Firewall Logs Trace:"
        grep -wF "$TERM_ARG" "$FIREWALL_LOG"
    else
        echo ">>> Firewall logs trace: No perimeter alerts matched."
    fi
    
    if [ -f "$IOC_FILE" ] && grep -qxF "$TERM_ARG" "$IOC_FILE"; then
        echo "CRITICAL WARNING: This IP is explicitly flagged in intel/iocs.txt!"
    else
        echo "Intel Scan: IP not found in current IOC feeds."
    fi
    [ "$TOTAL_OCCURRENCES" -gt 0 ] && exit 0 || exit 4
else
    echo "Processing Mode: USER PROFILE CHECK [Account: $TERM_ARG]"
    FAIL_LOGINS=$(grep -c "Failed password for $TERM_ARG " "$LOGFILE_ARG")
    OK_LOGINS=$(grep -c "Accepted password for $TERM_ARG " "$LOGFILE_ARG")
    TOTAL_LOG_LINES=$((FAIL_LOGINS + OK_LOGINS))
    
    echo "Metrics Summary -> Successful entries: $OK_LOGINS | Unauthenticated entries: $FAIL_LOGINS"
    
    if grep -q "^$TERM_ARG," "$USER_CSV"; then
        ROLE_VAL=$(grep "^$TERM_ARG," "$USER_CSV" | cut -d',' -f3)
        STATUS_VAL=$(grep "^$TERM_ARG," "$USER_CSV" | cut -d',' -f4 | tr -d '\r')
        echo "Registry State: CURRENT (Role: $ROLE_VAL | Status: $STATUS_VAL)"
    elif [ -f "$USER_OLD" ] && grep -qx "$TERM_ARG" "$USER_OLD"; then
        echo "Registry State: LEGACY (Archived historical profiles)"
    else
        echo "Registry State: UNKNOWN (No account listing match found)"
    fi
    [ "$TOTAL_LOG_LINES" -gt 0 ] && exit 0 || exit 5
fi
