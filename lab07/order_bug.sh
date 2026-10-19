cat << 'EOF' > order_bug.sh
#!/bin/bash
COUNT=$1

if [ "$COUNT" -lt 0 ]; then
    echo "Negative"
elif [ "$COUNT" -ge 10 ]; then
    echo "At least 10"
else
    echo "Non-negative"
fi
EOF
