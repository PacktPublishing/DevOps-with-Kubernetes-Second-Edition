#!/bin/sh

SERVICENAME=${SERVICENAME:-custom-metrics-apiserver}
NAMESPACE=${NAMESPACE:-custom-metrics}
SECRETNAME=${SECRETNAME:-cm-adapter-serving-certs}

cat >openssl.conf << EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
    
[ dn ]
CN = ${SERVICENAME}
    
[ req_ext ]
subjectAltName = @alt_names
    
[ alt_names ]
DNS.1 = ${SERVICENAME}
DNS.2 = ${SERVICENAME}.${NAMESPACE}
DNS.3 = ${SERVICENAME}.${NAMESPACE}.svc

    
[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=critical,keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names
EOF

openssl req -x509 -sha256 -new -nodes -days 365 -newkey rsa:2048 -keyout cm-ca.key -out cm-ca.crt -subj "/CN=ca"
openssl genrsa -out cm.key 2048
openssl req -new -key cm.key -out cm.csr -config openssl.conf
openssl x509 -req -in cm.csr -CA cm-ca.crt -CAkey cm-ca.key -CAcreateserial -out cm.crt -days 365 -extensions v3_ext -extfile openssl.conf


cat << EOF | ./kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${SECRETNAME}
  namespace: ${NAMESPACE}
data:
  serving.crt: $(base64 < cm.crt | tr -d \\n)
  serving.key: $(base64 < cm.key | tr -d \\n)
EOF
