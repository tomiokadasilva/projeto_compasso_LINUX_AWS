#!/bin/bash

# Get current date and time
timestamp=$(date +%Y-%m-%d_%H:%M:%S)

# Check Apache status and set message accordingly
if systemctl is-active httpd > /dev/null 2>&1
then
    status="ONLINE"
    message="Server Online"
else
    status="OFFLINE"
    message="Server Offline"
fi

# Write output to files
echo "${timestamp} Apache ${status} ${message}" >> path/to/output/apache_${status}.log

