#!/bin/bash

# Set variables
REGION=us-east-1
AMI=ami-0c94855ba95c71c99 # Amazon Linux 2 AMI
INSTANCE_TYPE=t3.small
VOLUME_TYPE=gp3
VOLUME_SIZE=16
VPC_NAME="Compass Univesp Uri"
SECURITY_GROUP_NAME="Compass Univesp Uri"
KEY_NAME="PB Compass Univesp"
INSTANCE_NAME="PB UNIVEST URI"
COST_CENTER="C092000004"
PROJECT_NAME="PB UNIVEST URI"

# Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text --region $REGION)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value="$VPC_NAME" --region $REGION

# Create subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.0.0/24 --query 'Subnet.SubnetId' --output text --region $REGION)

# Create internet gateway
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text --region $REGION)
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION

# Create route table
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text --region $REGION)

# Add route to internet gateway
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION

# Associate subnet with route table
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID --region $REGION

# Create security group
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "$SECURITY_GROUP_NAME" --description "Security group for Compass Univesp Uri" --vpc-id $VPC_ID --query 'GroupId' --output text --region $REGION)
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 111 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol udp --port 111 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 2049 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol udp --port 2049 --cidr 0.0.0.0/0 --region $REGION

echo "Security group $SECURITY_GROUP_ID has been created in the $REGION region."

# Create key pair
aws ec2 create-key-pair --key-name "$KEY_NAME" --query 'KeyMaterial' --output text > "$KEY_NAME.pem"
chmod 400 "$KEY_NAME.pem"

# Launch EC2 instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI --count 1 --instance-type $INSTANCE_TYPE --key-name "$KEY_NAME" --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID --block-device-mappings "[{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"VolumeSize\":$VOLUME_SIZE,\"DeleteOnTermination\":true}}]" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME},{Key=CostCenter,Value=$COST_CENTER},{Key=Project,Value=$PROJECT_NAME},{Key=ResourceType,Value=instance}]" --output text --region $REGION --query 'Instances[0].InstanceId')

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION

# Wait for system status check to pass
aws ec2 wait instance-status-ok --instance-ids $INSTANCE_ID --region $REGION

# Get public IP address of instance
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --region $REGION --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "EC2 instance with ID $INSTANCE_ID and Public IP $PUBLIC_IP has been launched in the $REGION region."

# Create EBS volume
VOLUME_ID=$(aws ec2 create-volume --size $VOLUME_SIZE --availability-zone ${REGION}a --volume-type $VOLUME_TYPE --query 'VolumeId' --output text --region $REGION)
aws ec2 wait volume-available --volume-ids $VOLUME_ID --region $REGION

# Attach EBS volume to instance
aws ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device /dev/xvdf --region $REGION

# Allocate Elastic IP address
ELASTIC_IP=$(aws ec2 allocate-address --domain vpc --query 'PublicIp' --output text --region $REGION)

# Associate Elastic IP address with instance
aws ec2 associate-address --instance-id $INSTANCE_ID --public-ip $ELASTIC_IP --region $REGION

# Add tags to instance and volume
aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value="$INSTANCE_NAME" Key=CostCenter,Value="$COST_CENTER" Key=Project,Value="$PROJECT_NAME" Key=ResourceType,Value=volume --region $REGION
aws ec2 create-tags --resources $VOLUME_ID --tags Key=Name,Value="$INSTANCE_NAME" Key=CostCenter,Value="$COST_CENTER" Key=Project,Value="$PROJECT_NAME" Key=ResourceType,Value=volume --region $REGION

echo "EC2 instance with ID $INSTANCE_ID has been provisioned in the $REGION region."