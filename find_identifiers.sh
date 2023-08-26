#!/bin/bash

# Usage: ./find_identifiers.sh <source_folder>

# Extract all jmod files then all the classes will be available for later usage
echo "Extracting jmod files.."
source_folder="$1"

find /usr/lib/jvm/jdk-20 -name *.jmod -exec jmod extract --dir $source_folder/sources {} \;
echo "Extracted all jmod files into $source_folder/sources!"

echo "Collecting  all .class files.."
find $source_folder/sources -name *.class -exec javap -constants -public -classpath $source_folder/sources {} \; > ./identifiers.txt
echo "All decompiled .class collected into $source_folder/identifiers.txt"
