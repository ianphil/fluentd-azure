#!/bin/bash

echo '
{
	"docker":{
		"port": "2376",
		"options": ["-D", "--dns=8.8.8.8"]
	}
}
' > pub.json
