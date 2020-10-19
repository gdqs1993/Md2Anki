#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Make script stop when an error happens
set -e

# Go to script directory even when run from another one
cd "$SCRIPT_DIR"

# Use run script from root to create all demos for all found markdown files
find . -maxdepth 1 -type f -name "*.md" | while read md_filename
do
	../run.sh "examples/$md_filename" \
	          -o-anki "examples/backup_$(basename "$md_filename" .md)/$(basename "$md_filename" .md).apkg" \
	          -file-dir "examples" \
	          -o-backup-dir "examples/backup_$(basename "$md_filename" .md)" \
	          "$@"
done

# Use run script from root to create all demo backups for all found markdown files
find . -mindepth 2 -maxdepth 2 -type f -name "*.md" | while read md_filename
do
	../run.sh "examples/$md_filename" \
	          -o-anki "examples/$(basename "$md_filename" .md).apkg" \
	          -file-dir "examples/$(dirname "$md_filename")" \
	          "$@"
done
