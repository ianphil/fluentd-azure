#!/bin/bash

# Increase max_map_count
sysctl -w vm.max_map_count=262144

# Run the container
docker run -d -p 9200:9200 -p 9300:9300 elasticsearch
