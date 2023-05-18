#!/bin/bash

# Check for input file
if [ ! -f "$1" ]; then
  echo "Input file not found!"
  exit 1
fi

# Input file containing Java decompiled code
input_file=$1

# Regular expression for matching Java classes, interfaces, enums
regex='^public +(abstract +)?(class|interface|enum) +([a-zA-Z_$][a-zA-Z0-9_$]*)'

# Extract desired lines and filter out unwanted lines
names=$(grep -E "$regex" "$input_file" | sed -E 's/^public +(abstract +)?(class|interface|enum) +//' | sed -E 's/ +extends.*//; s/ +implements.*//; s/ +\{.*//' | grep -v '\.$')

# Extract last name after .
#names=$(echo $names | grep -o '[^.]*$')
#names=$(echo $names | rev | cut -d"." -f1 | rev)
#names=$(echo $names | sed -E "s/.*\. \?//g")
names=$(echo "$names" | awk -F '.' '{print $NF}' | awk '{gsub(/<.*/, ""); print}')

# Sort and remove duplicates
#names=$(echo $names | sort | uniq)

# Remove type parameters from the names
#names=$(echo "$names" | sed -E "s/<[^>]*//g")

# Remove package hierarchies and keep only identifiers
#names=$(echo "$names" | sed -E 's/^.*\.([^.]+\$)?([^.]+\$)?([^.]+\$)?([^.]+\$)?([^.]+)$/\1\n\2\n\3\n\4\n\5/')

# Remove empty lines
#names=$(echo "$names" | sed '/^$/d')

# Wrap each line in ""
#names=$(echo "$names" | sed 's/.*/"&",/')

output="./foundIdentifiers.txt"

# Save the names
temp="$(mktemp)"
echo "$names" > "$temp"

cat "$temp" | sort | uniq > "$output"

echo "Found all class|interface names and saved to $output"

echo "vim $output" | xclip -sel clip

