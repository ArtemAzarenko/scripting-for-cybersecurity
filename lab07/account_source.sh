cat << 'EOF' > account_source.sh
#!/bin/bash
USERNAME=$1

if grep -q "^$USERNAME," intel/users.csv; then
    echo "$USERNAME: CURRENT account"
elif grep -qx "$USERNAME" case/backups/users.old; then
    echo "$USERNAME: LEGACY account (only in the old backup list)"
else
    echo "$USERNAME: UNKNOWN account (in neither list)"
fi
EOF
