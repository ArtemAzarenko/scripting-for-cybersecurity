#!/bin/bash
for FILE in case/evidence/*; do
    if [ -f "$FILE" ]; then
        sha256sum "$FILE"
    fi
done
