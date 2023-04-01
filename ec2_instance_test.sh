#!/bin/bash

set -x

# Definir variáveis
INSTANCE_ID=$1
PATH_TO_KEY_PAIR=$2

# Retorna Endereço de IP Público
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

# Recuperar a chave pública para a instância
aws ec2 get-console-output --instance-id $INSTANCE_ID | grep 'Public key:' | cut -d ':' -f 2

# Verificar o sistema operacional
ssh -i $PATH_TO_KEY_PAIR ec2-user@$PUBLIC_IP "uname -a"

# Verificar o IP elástico
aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations[].Instances[].PublicIpAddress"

# Retorna ID da VPC
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=CompassAWS" --query "Vpcs[0].VpcId"

# Verificar quais portas estão abertas
aws ec2 describe-security-groups --filters Name=vpc-id,Values=vpc-09ad72f7c98e62ebb --query "SecurityGroups[].IpPermissions[]"

# Verificar o tipo de instância e os volumes associados
aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations[].Instances[].{InstanceType: InstanceType, Volumes: BlockDeviceMappings[].Ebs.VolumeId}"
