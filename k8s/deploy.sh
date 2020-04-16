#!/bin/sh
#
# make sure you have the secret set up in secretsmanager first!
# something like:
#    aws secretsmanager create-secret --name nessus-license --secret-string <Nessus-License-String>
#
set -e
K8SPATH=$(dirname "$0")

# update the secret if exists, otherwise just create it
LICENSE="$(aws secretsmanager get-secret-value --secret-id nessus-license | jq -r '.SecretString')"
if kubectl get secrets | grep nessus-secrets >/dev/null ; then
	kubectl create secret generic nessus-secrets --from-literal=license="$LICENSE" -o yaml --dry-run=client | kubectl replace -f -
else
	kubectl create secret generic nessus-secrets --from-literal=license="$LICENSE"
fi

# deploy the thing!
kubectl apply -f "$K8SPATH/nessus-volume.yaml"
kubectl apply -f "$K8SPATH/nessus-volumeclaim.yaml"
kubectl apply -f "$K8SPATH/nessus-deployment.yaml"
kubectl apply -f "$K8SPATH/nessus-service.yaml"
