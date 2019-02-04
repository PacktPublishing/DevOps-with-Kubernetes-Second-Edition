#!/bin/sh -ex

# get and config kubectl:
# CI_ENV_K8S_MASTER, CI_ENV_K8S_CA, and CI_ENV_K8S_SA_TOKEN are configured on Travis CI console
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl && sudo mv kubectl /usr/local/bin

echo ${CI_ENV_K8S_CA} | base64 --decode > ca.crt

kubectl config set-cluster mycluster --server=${CI_ENV_K8S_MASTER} --certificate-authority=ca.crt --embed-certs=true
kubectl config set-credentials mysa --token=${CI_ENV_K8S_SA_TOKEN}
kubectl config set-context myctxt --cluster=mycluster --user=mysa
kubectl config use-context myctxt

# deploy
sed -i s@{{IMAGE_PATH}}@${RELEASE_IMAGE_PATH}@g deployment/deployment.yml
kubectl apply -f deployment -n ${RELEASE_TARGET_NAMESPACE}
kubectl rollout status -f deployment/deployment.yml -n ${RELEASE_TARGET_NAMESPACE}
