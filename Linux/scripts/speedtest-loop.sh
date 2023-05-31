#!/bin/bash

# Check if speedtest-cli is installed
if [ ! command -v speedtest-cli &> /dev/null ]
then
    echo "speedtest-cli not found. Installing..."
    sudo apt-get update
    sudo apt-get install speedtest-cli
fi


# Check for valid input
if [ $# -eq 2 ] && [[ $1 =~ ^[0-9]+$ ]] && [[ $2 =~ ^[0-9]+$ ]]
then 

	# Set variables
	c=$1
	int=$2

	# Create CSV file
	echo "Date,Time,Download Speed (Mbps),Upload Speed (Mbps)" > speedtest.csv

	# Loop to run speedtest and move data to CSV file
	i=0
	while [ $c -eq 0 ] || [ $i -lt $c ]
	do

		timestamp=$(date "+%Y-%m-%d,%H:%M:%S")
                download_speed=$(speedtest-cli --simple | awk '/Download/{print $2}')
                upload_speed=$(speedtest-cli --simple | awk '/Upload/{print $2}')
                echo "$timestamp,$download_speed,$upload_speed" >> speedtest.csv
                sleep $int
                ((i++))

	done
	echo "Speedtest complete. Results saved to speedtest.csv"
	cat "speedtest.csv"
else
    echo " $0 <count> <interval>"
    echo "<count> is the number of lines to create (0 will run infinitely), (negative number would not be accepted)"
    echo "<interval> is the number in seconds to wait between each call to speedtest"
    exit 1

fi


