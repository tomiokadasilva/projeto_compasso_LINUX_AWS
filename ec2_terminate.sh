#!/bin/bash

# Define o ID da Instância para ser excluida
INSTANCE_ID=<your-instance-id>

# Pega o ID dos Security Groups associados
SG_IDS=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[].Instances[].SecurityGroups[].GroupId' --output text)

# Dá Release no Elastic IP associado à instância
ELASTIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp' --output text)
if [ -n "$ELASTIC_IP" ]; then
    echo "Releasing elastic IP $ELASTIC_IP"
    aws ec2 release-address --public-ip $ELASTIC_IP
fi

# Termina a Instância EC2
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

# Aguarda a Instância ser Terminada
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID

# Deleta os Security Groups Associados
for sg_id in $SG_IDS; do
    aws ec2 delete-security-group --group-id $sg_id
done

echo "Instance $INSTANCE_ID and associated resources have been terminated."
