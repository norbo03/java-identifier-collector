# java-identifier-collector
A simple (and not optimized) script collection to collect all publicly available identifiers from the Java Standard Library.

# Usage
Run `find_identifiers.sh <source_output>` to extract all jmod files from _/usr/lib/jvm/jdk-20_ into _<source_output>/identifiers.txt_. Then use `find_java_names.sh <extracted_sources>` with the previously extracted sources from jdk. This should generate a file called _foundIdentifiers.txt_ with all the public identifiers extracted.

#NOTE - These scripts are outdated and manual transformations on the results were applied to generate an appropriate result!
