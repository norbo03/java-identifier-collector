#!/bin/bash

# Usage: extract_identifiers.sh <filename>

filename="$1"

echo "Extracting all public identifiers from the Standard Java Library.."

# Create a temporary file with the compiled Java files content
mkdir -p ./tempFiles
temp_source=$(mktemp -p ./tempFiles/)
cp $filename $temp_source

# remove lines that are not Java code
sed -i '/^Compiled from/d' $temp_source
# remove some reserved keywords
sed -i 's/\bsynchronized\b//g' $temp_source
# remove method parameters
sed -i 's/(.*)//' $temp_source
# remove the created duplicate lines
temp_file=$(mktemp -p ./tempFiles/)
uniq $temp_source > $temp_file && mv $temp_file $temp_source

# echo "Sanitazied input and stored in: $temp_source"

# Extract public class and interface names 
# echo "Extracting class names.."
temp_class=$(mktemp -p ./tempFiles/)

grep -E '^[ ]*(public )?(interface|class) [^ ]+' "$temp_source" | awk '{print $3}' > $temp_class

# remove class hierarchy and template params
sed -i 's/.*\.//' $temp_class
sed -i 's/<.*>//' $temp_class

# remove lines that contains the class names
sed -i '/^\(public \)\?class [^ ]\+/d' $temp_source
# remove public keyword
sed -i 's/\bpublic\b//g' $temp_source
# remove class hierarchy and template params
sed -i 's/.*\.//' $temp_source
sed -i 's/<.*>//' $temp_source
# echo "Class names extracted and stored in $temp_class!"

# remove remaining keywords
#sed -E 's/\b(abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|enum|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|native|new|package|private|protected|public|return|short|static|strictfp|super|switch|synchronized|this|throw|throws|transient|try|void|volatile|while)\b//g' input_file > output_file
sed -i -E 's/\b(interface|static|boolean|char|void|byte|double|enum|float|int|long|native|short|transient|volatile)\b//g' $temp_source
# remove multiple spaces
sed -i 's/  \+/ /g' $temp_source

# extract the remaining keywords
temp_file=$(mktemp -p ./tempFiles/)
grep -oE "^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*" $temp_source > $temp_file && mv $temp_file $temp_source
temp_file=$(mktemp -p ./tempFiles/)
sed 's/ //g' $temp_source | grep -E '^[A-Za-z0-9_<>,]+\b' > $temp_file && mv $temp_file $temp_source
sed -i '/^\s*[EKTUSV]\s*$/d' $temp_source

# remove the created duplicate lines
temp_file=$(mktemp -p ./tempFiles/)
uniq -u $temp_source > $temp_file && mv $temp_file $temp_source

# Collect every public identifier in one file
result="./publicIdentifiers`date +%s`.txt"
cat $temp_source > $result
cat $temp_class >> $result

echo "All public identifiers collected into: $result"!

# remove temporary files
rm -r "./tempFiles/"
