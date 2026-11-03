#!/bin/bash
while IFS= read -r -d '' FILE; do
    echo "$FILE mentions target word ($(grep -c "password" "$FILE") line(s))"
done < <(grep -rlZ "password" case)
