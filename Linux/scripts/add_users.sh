#!/bin/bash

# Define the path to the file containing usernames
filename="$1"

# check if user is root
if [[ $(whoami) != "root" ]]; then
	echo "you must be root"
	exit 1
fi

if [[ "$filename" == "" ]]
then
	echo "please specify the file"
	exit 1

# Read the file and create each user
while read -r username
do
    # Create the user with a hd
    useradd -m -s /bin/bash "$username"

    # Defining the default password
    password="$username@123"

    # Set the password to "password" for the new user
    echo "$username:$password" | chpasswd

    # Print a message to confirm the user was created
    echo "User $username has been created."
done < "$filename"

