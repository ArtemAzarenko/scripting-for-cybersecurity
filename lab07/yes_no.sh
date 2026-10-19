cat << 'EOF' > yes_no.sh
#!/bin/bash
read -p "Enter yes or no: " ANSWER
ANSWER_LOWER="${ANSWER,,}"

if [ "$ANSWER_LOWER" = "yes" ]; then
    echo "Confirmed."
elif [ "$ANSWER_LOWER" = "no" ]; then
    echo "Cancelled."
else
    echo "Unrecognised answer: '$ANSWER'"
fi
EOF
