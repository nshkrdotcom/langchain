
#!/bin/bash

# Function to check if alias is used in file
check_and_fix_file() {
    local file=$1
    local content=$(cat "$file")
    local modified=false
    
    # Check each alias line and remove if unused
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*alias[[:space:]]([A-Za-z0-9.]+) ]]; then
            alias_name=${BASH_REMATCH[1]##*.}  # Get the last part after dot
            if ! grep -q "[^.]${alias_name}[^A-Za-z0-9]" "$file" || [[ $line =~ ^[[:space:]]*#.* ]]; then
                content=$(echo "$content" | grep -v "$line")
                modified=true
            fi
        fi
    done < "$file"
    
    if [ "$modified" = true ]; then
        echo "$content" > "$file"
        echo "Fixed: $file"
    fi
}

# Process all test files
find test/unit -name "*_test.exs" -type f | while read -r file; do
    check_and_fix_file "$file"
done
