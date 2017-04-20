#!/bin/bash

# Create a resource group
az group create -n fluentd-azure -l eastus

# Create a VM
az vm create -n dockervm -g fluentd-azure --image UbuntuLTS --admin-username tdr --authentication-type ssh

# Open Port 80
az vm open-port --resource-group fluentd-azure --name dockervm --port 80

# Create TLS Certs

# Create Public Docker config file

# Create protected Docker config file

# Add the Docker extension to the VM (with TLS)
az vm extension set \
  --resource-group fluentd-azure \
  --vm-name dockervm \ 
  --name DockerExtension \
  --publisher Microsoft.Azure.Extensions \
  --version 1.2.2 \
  --settings pub.json  \
  --protected-settings prot.json

# run Fluentd container

# < old > Add a custom script extension to install fluentd

# Start elastic Search

# Test fluentd

# Configure Docker damemon
