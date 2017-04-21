#!/bin/bash

ENC_CA=$(<keys/b64_ca.txt)
ENC_SVR_KEY=$(<keys/b64_server_key.txt)
ENC_SVR_CERT=$(<keys/b64_server_cert.txt)

echo '
{
    "certs": {
    	"ca": "'$ENC_CA'",
        "cert": "'$ENC_SVR_CERT'",
        "key": "'$ENC_SVR_KEY'"
    }
}
' > config/prot.json
