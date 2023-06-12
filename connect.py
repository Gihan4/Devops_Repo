import boto3
import subprocess

# AWS access key credentials
access_key_id = 'your-access-key-id'
secret_access_key = 'your-secret-access-key'

# Connect to AWS EC2 using access keys
ec2 = boto3.resource(
    'ec2',
    region_name='eu-central-1',
    aws_access_key_id=access_key_id,
    aws_secret_access_key=secret_access_key
)

# Connect to AWS EC2
ec2 = boto3.resource('ec2', region_name='eu-central-1')

# Retrieve the instance ID of the EC2 instance based on a specific condition
def get_instance_id():
    instances = ec2.instances.filter(Filters=[{'Name': 'tag:Name', 'Values': ['*']}])
    for instance in instances:
        return instance.id
    return None

# Get the dynamic instance ID
instance_id = get_instance_id()

# Check if instance ID is found
if instance_id is None:
    print("No instances found.")
else:
    # Retrieve the public IP address of the EC2 instance
    instance = ec2.Instance(instance_id)
    public_ip = instance.public_ip_address

    # Define the Ansible playbook path
    playbook_path = 'playbook.yml'

    # Run Ansible playbook to connect to the EC2 instance
    ansible_command = f"ansible-playbook -i '{public_ip},' {playbook.yml}"
    subprocess.call(ansible_command, shell=True)


# the script connects to AWS EC2, retrieves the instance ID dynamically based on the specified condition.
# checks if an instance is found, and then runs the Ansible playbook on the EC2 instance using the public IP address.
