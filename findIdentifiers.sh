#!/bin/bash


# Extract all jmod files then all the classes will be available for later usage
echo "Extracting jmod files.."
source_folder="/home/norbi/Desktop/ELTE/SpotBugs/research/identifiers"

find /usr/lib/jvm/jdk-20 -name *.jmod -exec jmod extract --dir $source_folder/sources {} \;
echo "Extracted all jmod files into $source_folder/sources!"

echo "Collecting  all .class files.."
find $source_folder/sources -name *.class -exec javap -constants -public -classpath $source_folder/sources {} \; > ./identifiers.txt
echo "All decompiled .class collected into $source_folder/identifiers.txt"

#"./extract_identifiers.sh" "$source_folder/identifiers.txt"
