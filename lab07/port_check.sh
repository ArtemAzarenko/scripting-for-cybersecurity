#!/bin/bash
CONF=$1
PORT=$(grep '^port=' "$CONF" | cut -d'=' -f2 | tr -d '\r')

if [ -z "$PORT" ]; then
    echo "$CONF: no port configured"
elif ! echo "$PORT" | grep -q '^[0-9]*$'; then
    echo "$CONF: configured port '$PORT' is a non-numeric string identifier"
elif [ "$PORT" -lt 1024 ]; then
    echo "$CONF: port $PORT is privileged (below 1024)"
else
    echo "$CONF: port $PORT is unprivileged"
fi
