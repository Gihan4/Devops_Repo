#!/bin/bash

# Set your AWS region and instance details
REGION="eu-central-1"
INSTANCE_TYPE="t2.micro"
INSTANCE_AMI="ami-07151644aeb34558a"
read -p "please specify the name of the instance: " INSTANCE_NAME
KEY_PAIR_NAME="gihan4"
SECURITY_GROUP_ID="sg-05e6d9a046e1ac332"

# Create a new EC2 instance
instance_id=$(aws ec2 run-instances \
  --region $REGION \
  --image-id $INSTANCE_AMI \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_PAIR_NAME \
  --security-group-ids $SECURITY_GROUP_ID \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$INSTANCE_NAME'}]' \
  --user-data '#!/bin/bash
    yum update -y
    yum install -y git python3-pip
    git clone https://github.com/Gihan4/DevOps-Crypto.git
    cd DevOps-Crypto/
    pip3 install flask
    nohup flask run --host=0.0.0.0 >/dev/null 2>&1 &' \
  --query 'Instances[0].InstanceId' \
  --output text)

# Wait for the instance to be in the 'running' state
echo "Waiting for instance to start..."
aws ec2 wait instance-running --region $REGION --instance-ids $instance_id

echo "Instance created with flask. Instance name: $INSTANCE_NAME"

IMAGE_NAME="MyAMI-$(date +"%Y-%m-%d-%H-%M-%S")"

# Create the AMI
image_id=$(aws ec2 create-image \
  --region $REGION \
  --instance-id $instance_id \
  --name $IMAGE_NAME \
  --description "AMI created from instance $INSTANCE_NAME" \
  --output text)

echo "AMI created with ID: $image_id"