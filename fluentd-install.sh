#!/bin/bash

# Download TD Agent install
curl -L http://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh -o install-td-agent.sh

# Install TD Agent 
sh install-td-agent.sh

# Start TD Agent (fluentd)
systemctl start td-agent

# Install Elastic search plugin
td-agent-gem install fluent-plugin-elasticsearch

# Create Fluentd config /etc/td-agent/td-agent.conf

# Restart TD Agent
systemctl restart td-agent
