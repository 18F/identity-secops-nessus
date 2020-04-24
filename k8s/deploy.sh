#!/bin/sh -x
#
# make sure you have the secret set up in secretsmanager first!
# something like:
#    aws secretsmanager create-secret --name nessus-license --secret-string <Nessus-License-String>
#
set -e
K8SPATH=$(dirname "$0")

if [ -z "$1" ] ; then
	echo "missing container image"
	exit 1
fi

# update the secret if exists, otherwise just create it
LICENSE="$(aws secretsmanager get-secret-value --secret-id nessus-license | jq -r '.SecretString')"
if kubectl get secrets | grep nessus-secrets >/dev/null ; then
	kubectl create secret generic nessus-secrets --from-literal=license="$LICENSE" -o yaml --dry-run | kubectl replace -f -
else
	kubectl create secret generic nessus-secrets --from-literal=license="$LICENSE"
fi

# deploy the thing using the proper config for the cluster we are in!
kubectl version
kubectl apply -k "$K8SPATH/$CLUSTER"
kubectl patch deployment nessus -p \
  "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"containerimage\":\"$1\"}}}}}"
echo "rollout triggered!"
