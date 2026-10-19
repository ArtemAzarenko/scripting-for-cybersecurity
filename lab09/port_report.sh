#!/bin/bash
REPORT=""
for CONF in case/configs/*.conf case/backups/config.old; do
    [ -f "$CONF" ] || continue
    PORT=$(grep '^port=' "$CONF" | cut -d'=' -f2 | tr -d '\r')
    DEBUG=$(grep '^debug=' "$CONF" | cut -d'=' -f2 | tr -d '\r')
    [ -z "$PORT" ] && PORT="(none)"
    [ -z "$DEBUG" ] && DEBUG="(none)"
    REPORT="${REPORT}${CONF} -> Port: ${PORT} | Debug: ${DEBUG}"$'\n'
done
echo "Configuration Environment Metrics Summary:"
echo "$REPORT"
