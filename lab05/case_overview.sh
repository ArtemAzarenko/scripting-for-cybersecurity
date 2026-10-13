#!/bin/bash
echo "Directories in the collection:"
find case -type d
echo ""
echo "Size of the collection:"
du -sh case
echo ""
echo "Log files:"
ls case/logs
echo ""
echo "Number of regular files:"
find case -type f | wc -l
echo "Done."
