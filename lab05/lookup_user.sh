#!/bin/bash
read -p "Enter a username to look up: " TARGET_USER
read -p "Enter a department to filter by: " TARGET_DEPT
echo "Searching account list for user '$TARGET_USER' in department '$TARGET_DEPT'..."
grep "$TARGET_USER" intel/users.csv | grep "$TARGET_DEPT"
