#!/bin/bash
WEB_LOG="case/logs/access.log"
if [ -f "$WEB_LOG" ]; then
    CLIENTS=$(awk '{print $1}' "$WEB_LOG" | sort -u)
    for IP in $CLIENTS; do
        if grep -qxF "$IP" intel/iocs.txt; then
            echo "$IP: already in IOC list"
        else
            echo "$IP: NOT in IOC list — candidate for web indicator"
        fi
    done
fi
