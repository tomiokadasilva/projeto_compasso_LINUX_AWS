#!/bin/bash

# Get current date and time
timestamp=$(date +%Y-%m-%d_%H:%M:%S)

# Check Apache status and set message accordingly
if systemctl is-active httpd > /dev/null 2>&1 #Verifica se o serviço apache está ativo e redireciona o output para o dispositivo /dev/null para que não apareça em tela. '2>&1 redireciona o output de erro padrão para o mesmo lugar que a saída padrão.'
then
    status="ONLINE"
    message="Server Online"
else
    status="OFFLINE"
    message="Server Offline"
fi

# Write output to files
echo "${timestamp} Apache ${status} ${message}" >> path/to/output/apache_${status}.log

