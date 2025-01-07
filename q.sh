#!/bin/bash

DIFF_FILE="diff"

if [ ! -f "$DIFF_FILE" ]; then
    echo "No diff file found"
    exit 1
fi

current_file=""
while IFS= read -r line; do
    if [[ $line == @"@ file:"* ]]; then
        current_file="${line#"@@ file: "}"
        # Create file if it doesn't exist
        touch "$current_file"
        # Create temp file
        temp_file=$(mktemp)
        cp "$current_file" "$temp_file"
    elif [[ $line == "-"* ]]; then
        # Remove line (skip it in temp file)
        old_line="${line#"-"}"
        grep -v "^$old_line$" "$temp_file" > "$temp_file.new"
        mv "$temp_file.new" "$temp_file"
    elif [[ $line == "+"* ]]; then
        # Add new line
        new_line="${line#"+"}"
        echo "$new_line" >> "$temp_file"
    elif [[ $line == "="* ]]; then
        # Keep line (already in temp file)
        continue
    fi
    
    # If we have a current file, update it with temp contents
    if [ -n "$current_file" ] && [ -f "$temp_file" ]; then
        cp "$temp_file" "$current_file"
    fi
done < "$DIFF_FILE"

# Cleanup
rm -f "$temp_file"

