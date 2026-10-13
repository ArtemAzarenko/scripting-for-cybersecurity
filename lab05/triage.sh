#!/bin/bash

# 1. Variables for directories
CASE_DIR="case"
EVIDENCE_DIR="$CASE_DIR/evidence"

# 2. Output filename variable
REPORT="triage-report-auto.txt"

# 1. Variables for directories (No hard-coded "case/" paths later)
CASE_DIR="case"
EVIDENCE_DIR="$CASE_DIR/evidence"

# 2. Output filename variable
REPORT="triage-report-auto.txt"

# 3. Ask the analyst for details
read -p "Enter Analyst Name: " ANALYST_NAME
read -p "Enter Case Reference: " CASE_REF

# 4. Write header to the report (Using '>' overwrites any old file)
echo "=========================================" > "$REPORT"
echo "DIGITAL FORENSIC TRIAGE REPORT" >> "$REPORT"
echo "=========================================" >> "$REPORT"
echo "Analyst:        $ANALYST_NAME" >> "$REPORT"
echo "Case Reference: $CASE_REF" >> "$REPORT"
echo "Date:           $(date)" >> "$REPORT"
echo "=========================================" >> "$REPORT"
echo "" >> "$REPORT"

# 5. Calculate and append metrics
echo "--- Summary Metrics ---" >> "$REPORT"

# Find total files and directories inside the case directory
total_files=$(find "$CASE_DIR" -type f | wc -l)
total_dirs=$(find "$CASE_DIR" -type d | wc -l)

# Count specific file extensions/types
# Note: Adjust case-sensitivity (-iname vs -name) if needed based on Lab 4
py_files=$(find "$CASE_DIR" -type f -name "*.py" | wc -l)
sh_files=$(find "$CASE_DIR" -type f -name "*.sh" | wc -l)
log_files=$(find "$CASE_DIR" -type f -name "*.log" | wc -l)
conf_files=$(find "$CASE_DIR" -type f -name "*.conf" | wc -l)
empty_files=$(find "$CASE_DIR" -type f -empty | wc -l)

# Standard archive extensions (.zip, .tar, .gz, .tgz)
archive_files=$(find "$CASE_DIR" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.tgz" \) | wc -l)

echo "Total Files: $total_files" >> "$REPORT"
echo "Total Directories: $total_dirs" >> "$REPORT"
echo "Python Files: $py_files" >> "$REPORT"
echo "Shell Scripts: $sh_files" >> "$REPORT"
echo "Log Files: $log_files" >> "$REPORT"
echo "Configuration Files: $conf_files" >> "$REPORT"
echo "Empty Files: $empty_files" >> "$REPORT"
echo "Archives: $archive_files" >> "$REPORT"
echo "" >> "$REPORT"

# 6. Append list of files containing 'admin'
echo "--- Files Containing 'admin' ---" >> "$REPORT"
grep -rl "admin" "$CASE_DIR" >> "$REPORT"
echo "" >> "$REPORT"

# 7. Append detected file types in the evidence folder
echo "--- Evidence File Types ---" >> "$REPORT"
file "$EVIDENCE_DIR"/* >> "$REPORT"
echo "" >> "$REPORT"

# 8. Calculate total scripts using arithmetic evaluation $(( ))
total_scripts=$((py_files + sh_files))
echo "Scripts (Python + shell): $total_scripts" >> "$REPORT"

echo "Triage report successfully generated at $REPORT"
