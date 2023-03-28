EC2 Instance Provisioning Script
This script provisions an Amazon EC2 instance with Amazon Linux 2 operating system in the us-east-1 region. It attaches an elastic IP to the instance and opens communication ports for public access. The instance is of t3.small Family with a 16 GB SSD, and a new VPC is created. A new security group named 'Compass Univesp Uri' is created and rules are added to authorize traffic on ports 22, 80, 443, 111/TCP and UDP, and 2049/TCP and UDP. A new key pair named 'PB Compass Univesp' is also created for instance access. Finally, tags are added to the instance to identify its purpose, cost center, project, and resource type.

Prerequisites
AWS CLI installed and configured with appropriate credentials.
Bash shell environment.
How to Use
Clone or download the script to your local machine.
Open a terminal and navigate to the directory where the script is located.
Make the script executable by running chmod +x ec2_provisioning.sh.
Set the necessary environment variables in the script, such as the VPC ID and region, and modify the script to fit your needs.
Run the script by executing ./ec2_provisioning.sh.
Wait for the script to complete. It may take a few minutes for the instance to launch and become available.
Once the script has completed, you should see the instance ID and public IP address printed to the console. You can use this information to access the instance.
License
This script is licensed under the MIT License. See the LICENSE file for details.
