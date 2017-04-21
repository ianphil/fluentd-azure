#!/bin/bash

export AZ_HOSTNAME='ipdockervm'
export AZ_LOCATION='eastus'
export AZ_RGROUP='fluentd-azure'
export AZ_DNSNAME=$AZ_HOSTNAME
export AZ_DNSPATH="$AZ_LOCATION.cloudapp.azure.com"
export AZ_DNSFQDN="$AZ_DNSNAME.$AZ_DNSPATH"

log () {
  echo "$1"
}

# Create a resource group
az group create -n $AZ_RGROUP -l $AZ_LOCATION

# Create a VM
log "Creating vm: $AZ_HOSTNAME"
az vm create -n $AZ_HOSTNAME \
  -g $AZ_RGROUP \
  --image UbuntuLTS \
  --admin-username tdr \
  --authentication-type ssh \
  --public-ip-address-dns-name $AZ_DNSNAME
log "$AZ_HOSTNAME created..."

# Open Ports: Docker TLS, Elasticsearch
log "$AZ_HOSTNAME: opening ports..."
az vm open-port --resource-group $AZ_RGROUP --name $AZ_HOSTNAME --port 2376 --priority 100
az vm open-port --resource-group $AZ_RGROUP --name $AZ_HOSTNAME --port 9200 --priority 110
log "$AZ_HOSTNAME ports created..."

# Create TLS Certs
log "Creating Certs"
sh scripts/tls-certs.sh
log "Certs created..."

# Create Public Docker config file
sh scripts/create-pub.sh

# Create protected Docker config file
sh scripts/create-prot.sh

# Add the Docker extension to the VM (with TLS)
log "Adding Docker VM extension to $AZ_HOSTNAME"
az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --name DockerExtension \
  --version 1.2.2 \
  --vm-name $AZ_HOSTNAME \
  --resource-group $AZ_RGROUP \
  --settings config/pub.json \
  --protected-settings config/prot.json
log "VM extension added to $AZ_HOSTNAME"

# Test TLS
log "Test connection to docker daemon"
docker --tlsverify \
  --tlscacert=keys/ca.pem \
  --tlscert=keys/cert.pem \
  --tlskey=keys/key.pem \
  -H=$AZ_DNSFQDN:2376 \
  version

# Copy fluentd config
scp -oStrictHostKeyChecking=no config/fluent.conf tdr@$AZ_DNSFQDN:~/fluent.conf

# Copy fluentd Dockerfile
scp config/Dockerfile tdr@$AZ_DNSFQDN:~/Dockerfile

# Build dockerfile with elasticsearch
log "Build custom fluentd image"
docker --tlsverify --tlscacert=keys/ca.pem --tlscert=keys/cert.pem --tlskey=keys/key.pem -H=$AZ_DNSFQDN:2376 build -t custom-fluent github.com/tripdubroot/fluentd-azure

# run Fluentd container
log "Run fluentd container"
docker --tlsverify \
  --tlscacert=keys/ca.pem \
  --tlscert=keys/cert.pem \
  --tlskey=keys/key.pem \
  -H=$AZ_DNSFQDN:2376 run \
  -itd -p 24224:24224 \
  custom-fluent

# Copy daemon.json Docker config for log-driver
ssh tdr@$AZ_DNSFQDN 'sudo curl https://raw.githubusercontent.com/tripdubroot/fluentd-azure/master/config/daemon.json -o /etc/docker/daemon.json'

# Resatart docker to use fluentd log driver
ssh tdr@$AZ_DNSFQDN 'sudo systemctl restart docker'

# Start elastic Search
log "Run elasticsearch container"
ssh tdr@$AZ_DNSFQDN 'sudo sysctl -w vm.max_map_count=262144'
docker --tlsverify \
  --tlscacert=keys/ca.pem \
  --tlscert=keys/cert.pem \
  --tlskey=keys/key.pem \
  -H=$AZ_DNSFQDN:2376 run \
  -d -p 9200:9200 -p 9300:9300 elasticsearch

# Test fluentd
log "test fluentd config"
sh scripts/test-fluentd.sh
