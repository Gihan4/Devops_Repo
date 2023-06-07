#!/bin/bash


echo "Enter the desired instance state: stop/start/destroy : "  
read state  

if [ -z "$state" ];
then
      echo "you must specify your input"
      exit 1
fi


if [ "$state" == "stop" ];
then

	# Retrieve the list of running EC2 instances
	instance_ids=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text)	

	# Stop each running EC2 instance
	for instance_id in $instance_ids; do
  		echo "Stopping instance: $instance_id"
  		aws ec2 stop-instances --instance-ids $instance_id
	done

	echo "All running EC2 instances have been requested to stop."
	


elif [ "$state" == "start" ];
then

	echo "Starting stopped EC2 instances..."
    	instance_ids=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped" --query "Reservations[].Instances[].InstanceId" --output text)
    	for instance_id in $instance_ids; do
      		echo "Starting instance: $instance_id"
      		aws ec2 start-instances --instance-ids $instance_id
    	done
    	echo "All stopped EC2 instances have been requested to start."


elif [ "$state" == "destroy" ];
then
	read -p "Are you sure you want to destroy all running EC2 instances? (y/n): " confirm
	if [ "$confirm" == "y" ]; then
		echo "Destroying EC2 instances with the tag 'temp'"
		instance_ids=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=temp" --query "Reservations[].Instances[].InstanceId" --output text)
		for instance_id in $instance_ids; do
			echo "Terminating instance: $instance_id"
			aws ec2 terminate-instances --instance-ids $instance_id
		done
		echo "All EC2 instances with the tag 'temp' have been terminated."
	else
		echo "operation canceled"
	fi
else

    echo "Invalid action parameter: $state"
    echo "Please provide a valid action parameter: --stop, --start, or --destroy"
    exit 1 
fi
