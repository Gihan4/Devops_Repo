#!/bin/bash

# the script is trying to figure whether two strings of letters are alike, if not the output is the count of non similarity. 

# checks whether the input is letters and 2 inputs  
if [[ ! $1 =~ ^[a-zA-Z]+$ ]] || [[ ! $2 =~ ^[a-zA-Z]+$ ]]
then
	echo " $0 <string> <string> "
	exit 1
fi

DNA1=$1
DNA2=$2

# checks if strings are not equal by length
if [[ ${#DNA1} != ${#DNA2} ]]; then
    echo "Strings must be equal by length."
    exit 1
fi

# loop that searches for hammings and keeps the count
c=0
for ((i=0; i<${#DNA1}; i++)); do
    if [ "${DNA1:i:1}" != "${DNA2:i:1}" ]; then
        ((c=c+1))
    fi
done

echo "the Hamming distance is $c"






