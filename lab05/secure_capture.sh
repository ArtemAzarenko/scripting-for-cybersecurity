#!/bin/bash
read -p "Username: " ENTRY_USER
read -s -p "Password: " ENTRY_PASS
echo ""
echo "Credentials captured for $ENTRY_USER (password length: ${#ENTRY_PASS})"
