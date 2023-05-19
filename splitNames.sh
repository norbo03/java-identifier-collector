#!/bin/bash

input_file="./foundIdentifiers.txt"

# Create a directory to store the output files
output_dir="./splitted"
mkdir -p "$output_dir"

# Iterate through each letter of the alphabet
for letter in {a..z}; do
    # Create a temporary file for lines starting with the current letter
    temp_file=$(mktemp)

    # Use awk to filter lines starting with the current letter (case-insensitive)
    awk -v letter="$letter" 'tolower(substr($0,1,1)) == tolower(letter)' "$input_file" > "$temp_file"

    # Check if any lines matched the pattern
    if [ -s "$temp_file" ]; then
        # Generate the output file path based on the current letter
        output_file="$output_dir/output_$letter.txt"

        # Move the temporary file to the output file
        mv "$temp_file" "$output_file"
    else
        # Delete the empty temporary file
        rm "$temp_file"
    fi
done

