#!/bin/bash


# Check if the number of arguments is correct
if [ $# -ne 2 ]; then
    echo "please type-For Example: <extension> <directory>"
    exit 1
fi

# Assign the arguments to variables
ext=$1
dir=$2

#checks if the directory exists 
if [ ! -d "$dir" ]; then
	echo "the $dir does not exist"
	exit 1
fi

# Change the extension of each file in the directory
for file in "$dir"/*;
 do
    # checks whether a file exists and is a regular file 
    if [ -f "$file" ]; then
	# extract the filename
        filename=$(basename -- "$file")
        # extract the extension from the filename. ##*. keeps only the ext of the filename
        extension="${filename##*.}"
        # checks if the file does not have the same extension
        if [ "$extension" != "$ext" ]; then
            # changes the name of the file to the direct path. %.* removes the ext of the filename 
            mv "$file" "$dir/${filename%.*}.$ext"
	    echo "the file $dir/${filename%.*}.$ext has been changed successfuly"
        fi
    fi
done
#
find $dir -type f

