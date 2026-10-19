cat << 'EOF' > nested_check.sh
#!/bin/bash
FILE=$1

if [ -f "$FILE" ]; then
    echo "$FILE exists."
    LINES=$(wc -l < "$FILE")
    if [ "$LINES" -eq 0 ]; then
        echo "  ...but it has no lines."
    else
        echo "  ...and has $LINES lines."
    fi
else
    echo "$FILE does not exist — skipping the line count entirely."
fi
EOF
