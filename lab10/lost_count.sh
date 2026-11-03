# lost_count.sh
#!/bin/bash
COUNT=0
find case -type f -name "*.log" -print0 |
while IFS= read -r -d '' LOGFILE; do
    COUNT=$((COUNT + 1))
done
echo "after the loop:  COUNT=$COUNT"
