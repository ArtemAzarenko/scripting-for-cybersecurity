#!/bin/bash
PORT_22=0
PORT_80=0
PORT_443=0

while read -r ACTION SRC ARROW DST || [ -n "$DST" ]; do
    PORT=${DST##*:}
    if [ "$ACTION" = "BLOCK" ]; then
        echo "BLOCKED connection from $SRC to port $PORT"
        [ "$PORT" -eq 22 ] && PORT_22=$((PORT_22 + 1))
        [ "$PORT" -eq 80 ] && PORT_80=$((PORT_80 + 1))
        [ "$PORT" -eq 443 ] && PORT_443=$((PORT_443 + 1))
    fi
done < case/logs/firewall.log

echo "Blocked targets summary -> Port 22: $PORT_22 | Port 80: $PORT_80 | Port 443: $PORT_443"
