#!/bin/bash

# Run container with fluentd driver
docker --tlsverify \
  --tlscacert=keys/ca.pem \
  --tlscert=keys/cert.pem \
  --tlskey=keys/key.pem \
  -H=$AZ_DNSFQDN:2376 run ubuntu /bin/echo 'Hello world'

# Curl Elastic search
curl -XGET "http://$AZ_DNSFQDN:9200/_all/_search?q=*"

# Expected value
# {"took":2,"timed_out":false,"_shards":{"total":1,"successful":1,"failed":0},"hits":{"total":1,"max_score":1.0,"hits":[{"_index":"logstash-2016.12.02","_type":"fluentd","_id":"AVQwUi-UHBhoWtOFQKVx","_score":1.0,"_source":{"container_id":"d16af3ad3f0d361a1764e9a63c6de92d8d083dcc502cd904155e217f0297e525","container_name":"/nostalgic_torvalds","source":"stdout","log":"Hello world","@timestamp":"2016-12-02T14:59:26-06:00"}}]}}