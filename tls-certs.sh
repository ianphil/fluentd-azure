#!/bin/bash

# Create CA key
openssl genrsa -aes256 -passout pass:asdfasdf -out keys/ca-key.pem 4096 

# Create CA cert
openssl req -subj "/CN=$AZ_DNSPATH/O=Microsoft/C=US" -new -x509 -days 365 -passin pass:asdfasdf -key keys/ca-key.pem -sha256 -out keys/ca.pem

# Create CSR for server cert
openssl genrsa -out keys/server-key.pem 4096
openssl req -subj "/CN=$AZ_DNSFQDN" -sha256 -new -key keys/server-key.pem -passout pass:asdfasdf -out keys/server.csr

# Extend with daemon host/ip
echo subjectAltName = DNS:$AZ_DNSFQDN,IP:127.0.0.1 > keys/extfile.cnf

# Create server cert
openssl x509 -req -days 365 -sha256 -in keys/server.csr -CA keys/ca.pem -CAkey keys/ca-key.pem -passin pass:asdfasdf \
-CAcreateserial -out keys/server-cert.pem -extfile keys/extfile.cnf

# Create CSR for client cert
openssl genrsa -out keys/key.pem 4096
openssl req -subj '/CN=client' -new -key keys/key.pem -out keys/client.csr

# Extend for client auth
echo extendedKeyUsage = clientAuth > keys/extfile.cnf

# Sign client key
openssl x509 -req -days 365 -sha256 -in keys/client.csr -CA keys/ca.pem -CAkey keys/ca-key.pem -passin pass:asdfasdf  \
-CAcreateserial -out keys/cert.pem -extfile keys/extfile.cnf

# Remove CSR
rm -v keys/client.csr keys/server.csr

# Base64 encode CA
cat keys/ca.pem | base64 > keys/b64_ca.txt

# Base64 encode server cert
cat keys/server-cert.pem  | base64 > keys/b64_server_cert.txt

# Base64 encode client cert
cat keys/server-key.pem | base64 > keys/b64_server_key.txt
