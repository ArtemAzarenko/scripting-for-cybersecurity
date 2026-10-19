#!/bin/bash
CONF=$1
TLS=$(grep '^tls=' "$CONF" | cut -d'=' -f2 | tr -d '\r')

if [ -z "$TLS" ]; then
    echo "$CONF: no tls setting configured"
elif [ "$TLS" = "true" ]; then
    echo "$CONF: tls mode is ON (Secure)"
elif [ "$TLS" = "false" ]; then
    echo "$CONF: tls mode is OFF (Insecure)"
else
    echo "$CONF: unexpected tls value '$TLS'"
fi
